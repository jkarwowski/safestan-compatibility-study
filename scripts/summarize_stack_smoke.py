#!/usr/bin/env python3
"""Combine completed, non-overlapping smoke-test shards and verify their inputs."""
import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import signal

ROOT = Path(__file__).resolve().parents[1]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def diagnostics(text):
    candidates = [line.strip() for line in text.splitlines() if any(s in line.lower() for s in ["exception:", "error:", "assertion failed", "initialization failed", "error during processing"])]
    return list(dict.fromkeys(candidates))[:5]


def summarize(runs, root=ROOT):
    expected = {str(p.parent.relative_to(root)): p.parent for p in (root / "models/the_stack").glob("*/model.stan")}
    if not expected:
        raise ValueError("No models found")
    collected = {}
    workers = []
    protocol = None
    for run in runs:
        state = json.loads((run / "status.json").read_text())
        if state["state"] != "complete":
            raise ValueError("Shard has not finished: " + str(run))
        settings = state["settings"]
        current_protocol = {k: settings[k] for k in ["warmup", "samples", "seed", "adaptation", "stepsize", "max_depth", "build_timeout", "run_timeout"]}
        if protocol is not None and current_protocol != protocol:
            raise ValueError("Shards used different sampling settings or timeouts")
        protocol = current_protocol
        worker = "worker-" + str(len(workers) + 1)
        workers.append({"id": worker, **{k: v for k, v in settings.items() if k not in {"host", "cmdstan", "make_args"}}, "optimization": "O=0", "precompiled_headers": True})
        records = [json.loads(line) for line in (run / "results.jsonl").read_text().splitlines()]
        if state["planned"] != len(records) or state["completed"] != len(records) or state["counts"] != dict(Counter(r["status"] for r in records)):
            raise ValueError("Shard completion summary does not match its results")
        for r in records:
            model = r["model"]
            if model in collected or model not in expected:
                raise ValueError("Duplicate or unexpected result: " + model)
            if sha(expected[model] / "model.stan") != r["source_sha256"] or sha(expected[model] / "data.json") != r["data_sha256"]:
                raise ValueError("Tested source/data differ from checked-in files: " + model)
            if r["status"] == "passed" and (r["build"]["returncode"] != 0 or r["build"]["timed_out"] or r["run"]["returncode"] != 0 or r["run"]["timed_out"] or r["output"]["draws"] != settings["samples"] or not r["output"]["finite_log_probability"] or not r["output"]["valid"]):
                raise ValueError("Successful result does not satisfy the smoke-test criterion: " + model)
            result = {k: r[k] for k in ["model", "source_sha256", "data_sha256", "status", "started", "completed"]}
            result["worker"] = worker
            for phase in ["build", "run"]:
                if phase in r:
                    result[phase] = {k: v for k, v in r[phase].items() if k not in {"command", "log"}}
                    if r[phase]["returncode"] < 0:
                        result[phase]["signal"] = signal.Signals(-r[phase]["returncode"]).name
            if "output" in r:
                result["output"] = r["output"]
            if "failure_kind" in r:
                result["failure_kind"] = r["failure_kind"]
                phase = "build" if r["status"].startswith("build") else "run"
                log = run / "models" / expected[model].name / (phase + ".log")
                text = log.read_text(errors="replace") if log.exists() else r.get("failure_excerpt", "")
                # Public reports need logical model paths, not host/user paths.
                text = re.sub(r"(?:/Users/[^\s'\"]+|/home/[^\s'\"]+|/private/tmp/[^\s'\"]+)/models/" + re.escape(expected[model].name) + r"/", model + "/", text)
                result["diagnostics"] = diagnostics(text)
            collected[model] = result
    if set(collected) != set(expected):
        raise ValueError(f"Expected {len(expected)} results, received {len(collected)}")
    rows = sorted(collected.values(), key=lambda r: r["model"])
    passed = [r for r in rows if r["status"] == "passed"]
    return {
        "protocol": {"chains": 1, "algorithm": "NUTS", "optimization": "O=0", "checked_in_inputs_unchanged": True, **protocol},
        "success_criterion": "C++ build and process exit succeed; exactly the requested number of retained draws with finite lp__. Other non-finite outputs and divergences are recorded separately.",
        "total": len(rows), "counts": dict(Counter(r["status"] for r in rows)),
        "compiled": sum(r["build"]["returncode"] == 0 and not r["build"]["timed_out"] for r in rows),
        "failure_kinds": dict(Counter(r["failure_kind"] for r in rows if "failure_kind" in r)),
        "completed_with_divergences": sum(r["output"]["divergent_draws"] > 0 for r in passed),
        "completed_with_nonfinite_outputs": sum(bool(r["output"]["nonfinite_columns"]) for r in passed),
        "completed_without_recorded_divergences_or_nonfinite_outputs": sum(r["output"]["divergent_draws"] == 0 and not r["output"]["nonfinite_columns"] for r in passed),
        "limitations": ["This is a bounded execution smoke test, not convergence, posterior propriety or statistical validation.", "Failure with synthetic data does not establish that the model fails with appropriate real data and initialization.", "Timeouts are not successful validations.", "Build and run timeouts are separate; per-worker limits and compiler hashes are recorded."],
        "workers": workers, "results": rows,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--run", type=Path, action="append", required=True)
    parser.add_argument("--output", type=Path, default=ROOT / "runs_metadata/the_stack_runtime_smoke.json")
    args = parser.parse_args()
    payload = summarize(args.run)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(payload, indent=2, sort_keys=True, allow_nan=False) + "\n")
    print(json.dumps({k: v for k, v in payload.items() if k not in {"results", "workers"}}, indent=2))


if __name__ == "__main__":
    main()
