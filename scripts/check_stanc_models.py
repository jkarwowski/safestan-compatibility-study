#!/usr/bin/env python3
"""Run stanc over every model in the corpus and write a JSON report."""

from __future__ import annotations

import argparse
import json
import os
import subprocess
from collections import Counter
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MODELS_ROOT = ROOT / "models"
DEFAULT_STANC = Path("/Users/jacski/safe_stan/cmdstan/bin/stanc")
DEFAULT_REPORT = ROOT / "runs_metadata" / "stanc_non_safe_modernization_report.json"


@dataclass
class CheckResult:
    model: str
    ok: bool
    returncode: int | None
    category: str
    stdout: str
    stderr: str


def model_paths(models_root: Path) -> list[Path]:
    return sorted(models_root.glob("*/*/model.stan"))


def classify_failure(output: str) -> str:
    lowered = output.lower()
    if "timeout" in lowered:
        return "timeout"
    if "declaration of arrays by placing brackets after a variable name" in lowered:
        return "old_array_syntax"
    if "syntax error" in lowered or "parsing error" in lowered:
        return "syntax_error"
    if "semantic error" in lowered:
        return "semantic_error"
    if "lexer" in lowered or "lexing" in lowered:
        return "lexing_error"
    return "other"


def truncate(value: str, limit: int = 6000) -> str:
    if len(value) <= limit:
        return value
    return value[:limit] + "\n... [truncated]"


def check_one(path: Path, stanc: Path, args: list[str], timeout: float) -> CheckResult:
    rel = path.relative_to(ROOT).as_posix()
    command = [str(stanc), *args, str(path)]
    try:
        completed = subprocess.run(
            command,
            cwd=ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired as exc:
        stdout = truncate(exc.stdout or "")
        stderr = truncate((exc.stderr or "") + f"\ntimeout after {timeout:g}s")
        return CheckResult(rel, False, None, "timeout", stdout, stderr)

    ok = completed.returncode == 0
    output = completed.stdout + completed.stderr
    return CheckResult(
        model=rel,
        ok=ok,
        returncode=completed.returncode,
        category="ok" if ok else classify_failure(output),
        stdout=truncate(completed.stdout),
        stderr=truncate(completed.stderr),
    )


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2, sort_keys=True)
        handle.write("\n")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models-root", type=Path, default=DEFAULT_MODELS_ROOT)
    parser.add_argument("--stanc", type=Path, default=Path(os.environ.get("STANC", DEFAULT_STANC)))
    parser.add_argument("--report", type=Path, default=DEFAULT_REPORT)
    parser.add_argument("--jobs", type=int, default=min(8, os.cpu_count() or 1))
    parser.add_argument("--timeout", type=float, default=30.0)
    parser.add_argument(
        "--stanc-arg",
        action="append",
        default=["--allow-undefined", "--info"],
        help="Argument passed to stanc. Defaults to --allow-undefined and --info.",
    )
    args = parser.parse_args()

    paths = model_paths(args.models_root)
    results: list[CheckResult] = []
    with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as executor:
        futures = {
            executor.submit(check_one, path, args.stanc, args.stanc_arg, args.timeout): path
            for path in paths
        }
        for future in as_completed(futures):
            results.append(future.result())

    results.sort(key=lambda item: item.model)
    counts = Counter(result.category for result in results)
    payload = {
        "command": [str(args.stanc), *args.stanc_arg, "MODEL"],
        "safe_mode": False,
        "models_root": str(args.models_root),
        "total": len(results),
        "ok": counts.get("ok", 0),
        "fail": len(results) - counts.get("ok", 0),
        "categories": dict(sorted(counts.items())),
        "results": [asdict(result) for result in results],
    }
    write_json(args.report, payload)

    print(f"total: {payload['total']}")
    print(f"ok: {payload['ok']}")
    print(f"fail: {payload['fail']}")
    for category, count in sorted(counts.items()):
        print(f"{category}: {count}")
    if payload["fail"]:
        print("first failures:")
        for result in [item for item in results if not item.ok][:20]:
            print(f"  {result.category}: {result.model}")
    print(f"report: {args.report}")
    return 0 if payload["fail"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
