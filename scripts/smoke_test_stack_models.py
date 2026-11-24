#!/usr/bin/env python3
"""Build and briefly sample the checked-in Stack candidates, without editing them.

Each result records exact source/data hashes, separate build/run statuses, and
actual retained draws. Resuming keeps completed failures as well as successes.
"""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor, as_completed
import csv
import datetime
import hashlib
import json
import math
import os
from pathlib import Path
import platform
import resource
import shutil
import signal
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def now():
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def write_json(path, value):
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(value, indent=2, sort_keys=True, allow_nan=False) + "\n")
    tmp.replace(path)


def execute(command, cwd, log_path, timeout, memory_gb):
    start = time.monotonic()
    with log_path.open("w") as log:
        proc = subprocess.Popen([sys.executable, str(Path(__file__).resolve()), "--exec", json.dumps(command), "--memory-gb", str(memory_gb)], cwd=cwd, stdout=log, stderr=subprocess.STDOUT, start_new_session=True)
        timed_out = False
        try:
            returncode = proc.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            timed_out = True
            os.killpg(proc.pid, signal.SIGTERM)
            try:
                returncode = proc.wait(timeout=3)
            except subprocess.TimeoutExpired:
                os.killpg(proc.pid, signal.SIGKILL)
                returncode = proc.wait()
    return {"returncode": returncode, "timed_out": timed_out, "seconds": round(time.monotonic() - start, 3)}


def classify(log, stage):
    if stage == "build":
        if "Syntax error" in log or "Semantic error" in log:
            return "stanc_error"
        return "cpp_or_link_error"
    lower = log.lower()
    if "mismatch in dimension" in lower or "variable does not exist" in lower:
        return "data_shape_or_missing"
    if "is not a valid stan csv" in lower:
        return "output_error"
    if "error evaluating the log probability at the initial value" in lower:
        return "initialization_log_probability"
    if "error evaluating the log probability gradient" in lower:
        return "initialization_gradient"
    if "initialization failed" in lower:
        return "initialization"
    if "exception:" in lower or "error during processing" in lower:
        return "data_or_model_exception"
    return "runtime_error"


def inspect_csv(path, samples):
    if not path.exists():
        return {"valid": False, "reason": "missing CSV", "draws": 0}
    with path.open() as f:
        reader = csv.DictReader(line for line in f if line.strip() and not line.startswith("#"))
        rows = list(reader)
    if not rows:
        return {"valid": False, "reason": "no retained draws", "draws": 0}
    try:
        values = [{k: float(v) for k, v in row.items()} for row in rows]
    except (ValueError, TypeError):
        return {"valid": False, "reason": "invalid numeric CSV", "draws": len(rows)}
    finite_lp = all("lp__" in r and math.isfinite(r["lp__"]) for r in values)
    nonfinite = sorted({k for r in values for k, v in r.items() if not math.isfinite(v)})
    return {"valid": len(rows) == samples and finite_lp,
            "draws": len(rows), "finite_log_probability": finite_lp,
            "divergent_draws": sum(r.get("divergent__", 0) != 0 for r in values),
            "nonfinite_columns": nonfinite,
            "max_treedepth": max((int(r.get("treedepth__", 0)) for r in values), default=0)}


def run_one(item, args):
    source = ROOT / item["model"]
    work = args.output / "models" / source.name
    work.mkdir(parents=True, exist_ok=True)
    for name in ["model.stan", "data.json"]:
        shutil.copyfile(source / name, work / name)
    result = {**item, "host": platform.node(), "started": now()}
    build_command = ["make", "O=0", *args.make_arg, str(work / "model")]
    result["build"] = execute(build_command, args.cmdstan, work / "build.log", args.build_timeout, args.memory_gb)
    result["build"]["command"] = build_command
    result["build"]["log"] = str((work / "build.log").relative_to(args.output))
    if result["build"]["returncode"] != 0 or result["build"]["timed_out"]:
        text = (work / "build.log").read_text(errors="replace")
        result.update(status="build_timeout" if result["build"]["timed_out"] else "build_failed", failure_kind=classify(text, "build"), failure_excerpt=text[-8000:])
    else:
        command = [str(work / "model"), "sample", f"num_warmup={args.warmup}", f"num_samples={args.samples}", "save_warmup=0", "adapt", "engaged=0", "algorithm=hmc", "engine=nuts", "max_depth=4", "stepsize=0.01", "data", "file=" + str(work / "data.json"), "random", "seed=12345", "output", "file=" + str(work / "chain-1.csv"), "refresh=0"]
        result["run"] = execute(command, work, work / "run.log", args.run_timeout, args.memory_gb)
        result["run"]["command"] = command
        result["run"]["log"] = str((work / "run.log").relative_to(args.output))
        result["output"] = inspect_csv(work / "chain-1.csv", args.samples)
        if result["run"]["timed_out"]:
            result.update(status="run_timeout", failure_kind="runtime_timeout")
        elif result["run"]["returncode"] != 0:
            result.update(status="run_failed", failure_kind=classify((work / "run.log").read_text(errors="replace"), "run"))
        elif not result["output"]["valid"]:
            result.update(status="invalid_output", failure_kind="draw_count_or_nonfinite_log_probability")
        else:
            result["status"] = "passed"
        if result["status"] != "passed":
            result["failure_excerpt"] = (work / "run.log").read_text(errors="replace")[-8000:]
    for name in ["model", "model.o", "model.hpp", "model.d"]:
        (work / name).unlink(missing_ok=True)
    result["completed"] = now()
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cmdstan", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--jobs", type=int, default=6)
    parser.add_argument("--shards", type=int, default=1)
    parser.add_argument("--shard", type=int, action="append", default=[])
    parser.add_argument("--warmup", type=int, default=5)
    parser.add_argument("--samples", type=int, default=5)
    parser.add_argument("--build-timeout", type=float, default=180)
    parser.add_argument("--run-timeout", type=float, default=30)
    parser.add_argument("--memory-gb", type=int, default=4)
    parser.add_argument("--make-arg", action="append", default=[])
    parser.add_argument("--exec", help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.exec:
        limit = args.memory_gb * 1024**3
        resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
        # macOS sandboxed children cannot reliably lower memory rlimits.
        # Linux workers enforce an address-space cap; both hosts use timeouts.
        if sys.platform.startswith("linux"):
            resource.setrlimit(resource.RLIMIT_AS, (limit, limit))
        command = json.loads(args.exec)
        os.execvp(command[0], command)
    if not args.cmdstan or not args.output:
        parser.error("--cmdstan and --output are required")
    args.cmdstan = args.cmdstan.resolve()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=True)
    preflight = execute(["make", "--version"], args.cmdstan, args.output / "preflight.log", 15, args.memory_gb)
    if preflight["returncode"] != 0 or preflight["timed_out"]:
        raise RuntimeError("Test harness preflight failed; inspect preflight.log before running models")
    paths = sorted((ROOT / "models/the_stack").glob("*/model.stan"))
    chosen = set(args.shard or range(args.shards))
    items = [{"model": str(p.parent.relative_to(ROOT)), "source_sha256": sha(p), "data_sha256": sha(p.parent / "data.json")} for i, p in enumerate(paths) if i % args.shards in chosen]
    settings = {"cmdstan": str(args.cmdstan), "stanc_sha256": sha(args.cmdstan / "bin/stanc"), "host": platform.node(), "platform": platform.platform(), "warmup": args.warmup, "samples": args.samples, "seed": 12345, "adaptation": False, "stepsize": 0.01, "max_depth": 4, "make_args": ["O=0", *args.make_arg], "build_timeout": args.build_timeout, "run_timeout": args.run_timeout, "memory_gb": args.memory_gb if sys.platform.startswith("linux") else None}
    plan = {"settings": settings, "items": items}
    plan_path = args.output / "plan.json"
    if plan_path.exists() and json.loads(plan_path.read_text()) != plan:
        raise ValueError("Existing run has different inputs or settings; use a new output directory")
    write_json(plan_path, plan)
    result_path = args.output / "results.jsonl"
    results = [json.loads(line) for line in result_path.read_text().splitlines()] if result_path.exists() else []
    completed = {r["model"] for r in results}
    todo = [r for r in items if r["model"] not in completed]
    todo.sort(key=lambda r: -(ROOT / r["model"] / "model.stan").stat().st_size)
    started = now()
    def persist(state):
        write_json(args.output / "status.json", {"state": state, "started": started, "updated": now(), "planned": len(items), "completed": len(results), "counts": dict(Counter(r["status"] for r in results)), "settings": settings})
    persist("running")
    with ThreadPoolExecutor(max_workers=args.jobs) as pool, result_path.open("a") as f:
        futures = [pool.submit(run_one, r, args) for r in todo]
        for future in as_completed(futures):
            result = future.result()
            f.write(json.dumps(result, allow_nan=False) + "\n")
            f.flush()
            results.append(result)
            persist("running")
            if len(results) % 25 == 0 or len(results) == len(items):
                print(f"{len(results)}/{len(items)} {dict(Counter(r['status'] for r in results))}", flush=True)
    persist("complete")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
