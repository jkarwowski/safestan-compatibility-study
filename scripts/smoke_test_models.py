#!/usr/bin/env python3
"""Compile and run small sampling smoke tests for model directories.

The script wraps each model's `run.py`, writes per-model outputs outside the
repository by default, and writes an incremental JSON report after every model
so a long run can be inspected or resumed.
"""

from __future__ import annotations

import argparse
import json
import os
import signal
import subprocess
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MODELS_ROOT = ROOT / "models"
DEFAULT_OUTPUT_ROOT_BASE = Path("/tmp/stan-collection-runs")


@dataclass
class SmokeResult:
    model: str
    ok: bool
    returncode: int | None
    timed_out: bool
    elapsed_seconds: float
    output_dir: str
    log_file: str
    csv_count: int
    run_json_exists: bool
    command: list[str]
    log_tail: list[str] | None = None


def timestamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def discover_models(models_root: Path) -> list[Path]:
    return sorted(path.parent for path in models_root.glob("*/*/run.py") if (path.parent / "model.stan").exists())


def rel_model(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def load_existing(path: Path) -> dict[str, Any] | None:
    if not path.exists():
        return None
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def explicit_model_dirs(values: list[str], models_root: Path) -> list[Path]:
    dirs: list[Path] = []
    for value in values:
        path = Path(value).expanduser()
        if not path.is_absolute():
            path = ROOT / path if value.startswith("models/") else models_root / value
        path = path.resolve()
        if not (path / "run.py").exists() or not (path / "model.stan").exists():
            raise SystemExit(f"Model directory does not contain run.py and model.stan: {path}")
        dirs.append(path)
    return sorted(set(dirs))


def failed_model_dirs_from_report(report_path: Path) -> list[Path]:
    report = load_existing(report_path) or {}
    dirs: list[Path] = []
    for item in report.get("results", []):
        if item.get("ok"):
            continue
        model = ROOT / str(item.get("model", ""))
        if (model / "run.py").exists() and (model / "model.stan").exists():
            dirs.append(model.resolve())
    return sorted(set(dirs))


def write_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=2)
        handle.write("\n")


def log_tail(path: Path, lines: int = 80) -> list[str]:
    if not path.exists():
        return []
    return path.read_text(encoding="utf-8", errors="replace").splitlines()[-lines:]


def cleanup_model_build_artifacts(model_dir: Path) -> None:
    for name in ("model", "model.o", "model.hpp"):
        path = model_dir / name
        if path.exists() and path.is_file():
            path.unlink()


def run_one(
    *,
    model_dir: Path,
    cmdstan: Path,
    output_root: Path,
    chains: int,
    iter_warmup: int,
    iter_sampling: int,
    timeout: float,
    force_recompile: bool,
    cleanup_exe: bool,
    refresh: int,
) -> SmokeResult:
    rel = rel_model(model_dir)
    output_dir = output_root / rel
    log_file = output_root / "logs" / f"{rel.replace('/', '__')}.log"
    output_dir.mkdir(parents=True, exist_ok=True)
    log_file.parent.mkdir(parents=True, exist_ok=True)

    command = [
        "python3",
        str((model_dir / "run.py").relative_to(ROOT)),
        "--cmdstan",
        str(cmdstan),
        "--chains",
        str(chains),
        "--iter-warmup",
        str(iter_warmup),
        "--iter-sampling",
        str(iter_sampling),
        "--refresh",
        str(refresh),
        "--output-dir",
        str(output_dir),
    ]
    if force_recompile:
        command.append("--force-recompile")

    start = time.monotonic()
    timed_out = False
    returncode: int | None
    with log_file.open("w", encoding="utf-8") as log:
        try:
            proc = subprocess.Popen(
                command,
                cwd=ROOT,
                stdout=log,
                stderr=subprocess.STDOUT,
                text=True,
                start_new_session=True,
            )
            returncode = proc.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            timed_out = True
            returncode = None
            log.write(f"\nTIMEOUT after {timeout} seconds\n")
            log.flush()
            try:
                os.killpg(proc.pid, signal.SIGTERM)
                returncode = proc.wait(timeout=10)
            except (ProcessLookupError, subprocess.TimeoutExpired):
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
                returncode = proc.wait()
    elapsed = round(time.monotonic() - start, 3)

    csv_count = len(list(output_dir.glob("chain-*.csv")))
    run_json_exists = (output_dir / "run.json").exists()
    ok = returncode == 0 and csv_count == chains and run_json_exists

    if cleanup_exe:
        cleanup_model_build_artifacts(model_dir)

    return SmokeResult(
        model=rel,
        ok=ok,
        returncode=returncode,
        timed_out=timed_out,
        elapsed_seconds=elapsed,
        output_dir=str(output_dir),
        log_file=str(log_file),
        csv_count=csv_count,
        run_json_exists=run_json_exists,
        command=command,
        log_tail=None if ok else log_tail(log_file),
    )


def report_payload(
    *,
    run_id: str,
    models_root: Path,
    cmdstan: Path,
    output_root: Path,
    chains: int,
    iter_warmup: int,
    iter_sampling: int,
    timeout: float,
    jobs: int,
    planned_total: int,
    results: list[SmokeResult],
    started_at: float,
) -> dict[str, Any]:
    return {
        "run_id": run_id,
        "models_root": models_root.relative_to(ROOT).as_posix() if models_root.is_relative_to(ROOT) else str(models_root),
        "cmdstan": str(cmdstan),
        "chains": chains,
        "iter_warmup": iter_warmup,
        "iter_sampling": iter_sampling,
        "timeout_seconds": timeout,
        "jobs": jobs,
        "output_root": str(output_root),
        "planned_total": planned_total,
        "total": len(results),
        "ok": sum(result.ok for result in results),
        "fail": sum(not result.ok for result in results),
        "elapsed_seconds": round(time.monotonic() - started_at, 3),
        "results": [asdict(result) for result in sorted(results, key=lambda item: item.model)],
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models-root", type=Path, default=DEFAULT_MODELS_ROOT)
    parser.add_argument("--cmdstan", type=Path, default=Path(os.environ.get("CMDSTAN", "/Users/jacski/safe_stan/cmdstan")))
    parser.add_argument("--run-id", default=f"smoke-{timestamp()}")
    parser.add_argument("--output-root", type=Path, help="Defaults to /tmp/stan-collection-runs/<run-id>.")
    parser.add_argument("--report", type=Path, help="Defaults to runs_metadata/<run-id>.json.")
    parser.add_argument("--latest-report", type=Path, default=ROOT / "runs_metadata" / "smoke_test_latest.json")
    parser.add_argument("--model-dir", action="append", default=[], help="Specific model directory to test; repeatable.")
    parser.add_argument("--from-smoke-report", type=Path, help="Test failed model directories from a previous smoke report.")
    parser.add_argument("--jobs", type=int, default=1)
    parser.add_argument("--timeout", type=float, default=300.0)
    parser.add_argument("--chains", type=int, default=1)
    parser.add_argument("--iter-warmup", type=int, default=20)
    parser.add_argument("--iter-sampling", type=int, default=20)
    parser.add_argument("--refresh", type=int, default=0)
    parser.add_argument("--no-force-recompile", action="store_true")
    parser.add_argument("--keep-executables", action="store_true")
    parser.add_argument("--continue-on-failure", action="store_true", default=True)
    parser.add_argument("--stop-on-failure", action="store_false", dest="continue_on_failure")
    parser.add_argument("--resume", action="store_true", help="Skip models already marked ok in --report.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    models_root = args.models_root.expanduser().resolve()
    cmdstan = args.cmdstan.expanduser().resolve()
    run_id = args.run_id
    output_root = (args.output_root or DEFAULT_OUTPUT_ROOT_BASE / run_id).expanduser().resolve()
    report = (args.report or ROOT / "runs_metadata" / f"{run_id}.json").expanduser().resolve()
    latest_report = args.latest_report.expanduser().resolve()
    jobs = max(1, args.jobs)

    if args.model_dir or args.from_smoke_report:
        selected: list[Path] = []
        if args.from_smoke_report:
            selected.extend(failed_model_dirs_from_report(args.from_smoke_report.expanduser().resolve()))
        if args.model_dir:
            selected.extend(explicit_model_dirs(args.model_dir, models_root))
        models = sorted(set(selected))
    else:
        models = discover_models(models_root)
    existing_results: list[SmokeResult] = []
    completed_ok: set[str] = set()
    if args.resume:
        existing = load_existing(report)
        if existing:
            for item in existing.get("results", []):
                if item.get("ok"):
                    completed_ok.add(str(item["model"]))
                    existing_results.append(SmokeResult(**item))
    todo = [model for model in models if rel_model(model) not in completed_ok]

    started_at = time.monotonic()
    results = existing_results[:]
    planned_total = len(models)
    print(f"run_id: {run_id}", flush=True)
    print(f"models: {planned_total}", flush=True)
    print(f"todo: {len(todo)}", flush=True)
    print(f"output_root: {output_root}", flush=True)

    def persist() -> None:
        payload = report_payload(
            run_id=run_id,
            models_root=models_root,
            cmdstan=cmdstan,
            output_root=output_root,
            chains=args.chains,
            iter_warmup=args.iter_warmup,
            iter_sampling=args.iter_sampling,
            timeout=args.timeout,
            jobs=jobs,
            planned_total=planned_total,
            results=results,
            started_at=started_at,
        )
        write_json(report, payload)
        write_json(latest_report, payload)

    common = {
        "cmdstan": cmdstan,
        "output_root": output_root,
        "chains": args.chains,
        "iter_warmup": args.iter_warmup,
        "iter_sampling": args.iter_sampling,
        "timeout": args.timeout,
        "force_recompile": not args.no_force_recompile,
        "cleanup_exe": not args.keep_executables,
        "refresh": args.refresh,
    }

    if jobs == 1:
        for index, model_dir in enumerate(todo, 1):
            print(f"[{index:04d}/{len(todo):04d}] {rel_model(model_dir)}", flush=True)
            result = run_one(model_dir=model_dir, **common)
            results.append(result)
            persist()
            status = "ok" if result.ok else "FAIL"
            print(f"[{index:04d}/{len(todo):04d}] {status} {result.elapsed_seconds:.1f}s {result.model}", flush=True)
            if not result.ok and not args.continue_on_failure:
                break
    else:
        with ThreadPoolExecutor(max_workers=jobs) as executor:
            futures = {executor.submit(run_one, model_dir=model_dir, **common): model_dir for model_dir in todo}
            for index, future in enumerate(as_completed(futures), 1):
                result = future.result()
                results.append(result)
                persist()
                status = "ok" if result.ok else "FAIL"
                print(f"[{index:04d}/{len(todo):04d}] {status} {result.elapsed_seconds:.1f}s {result.model}", flush=True)
                if not result.ok and not args.continue_on_failure:
                    break

    persist()
    payload = load_existing(report) or {}
    print(
        json.dumps(
            {key: payload.get(key) for key in ("total", "planned_total", "ok", "fail", "elapsed_seconds", "run_id")},
            indent=2,
        ),
        flush=True,
    )
    return 0 if payload.get("fail") == 0 and payload.get("total") == payload.get("planned_total") else 1


if __name__ == "__main__":
    raise SystemExit(main())
