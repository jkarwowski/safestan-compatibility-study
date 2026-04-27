#!/usr/bin/env python3
"""Compare CmdStan CSV outputs from two suite runs."""

from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path
from statistics import mean, stdev


def csv_files(root: Path) -> list[Path]:
    return sorted(path for path in root.rglob("*.csv") if path.is_file())


def grouped_csvs(root: Path) -> dict[str, list[Path]]:
    groups: dict[str, list[Path]] = {}
    for path in csv_files(root):
        rel_parent = str(path.parent.relative_to(root))
        groups.setdefault(rel_parent, []).append(path)
    return groups


def read_draws(paths: list[Path]) -> dict[str, list[float]]:
    columns: dict[str, list[float]] = {}
    header: list[str] | None = None
    for path in paths:
        with path.open("r", encoding="utf-8") as handle:
            reader = csv.reader(line for line in handle if line.strip() and not line.startswith("#"))
            local_header = next(reader, None)
            if local_header is None:
                continue
            if header is None:
                header = local_header
                columns = {name: [] for name in header}
            elif local_header != header:
                raise ValueError(f"CSV header mismatch in {path}")
            for row in reader:
                if len(row) != len(header):
                    continue
                for name, value in zip(header, row):
                    columns[name].append(float(value))
    return columns


def summarize(values: list[float]) -> dict[str, float]:
    if not values:
        return {"n": 0, "mean": math.nan, "sd": math.nan}
    return {
        "n": float(len(values)),
        "mean": mean(values),
        "sd": stdev(values) if len(values) > 1 else 0.0,
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("baseline", help="Baseline run directory.")
    parser.add_argument("candidate", help="Candidate run directory.")
    parser.add_argument("--atol", type=float, default=1e-6)
    parser.add_argument("--rtol", type=float, default=1e-4)
    parser.add_argument("--exclude", action="append", default=[], help="Parameter column to exclude; repeatable.")
    parser.add_argument("--json-output", help="Optional JSON report path.")
    return parser.parse_args()


def within_tolerance(a: float, b: float, atol: float, rtol: float) -> bool:
    if math.isnan(a) or math.isnan(b):
        return False
    return abs(a - b) <= atol + rtol * max(abs(a), abs(b))


def main() -> int:
    args = parse_args()
    baseline = Path(args.baseline).expanduser().resolve()
    candidate = Path(args.candidate).expanduser().resolve()
    baseline_groups = grouped_csvs(baseline)
    candidate_groups = grouped_csvs(candidate)
    common_groups = sorted(set(baseline_groups) & set(candidate_groups))
    excluded = set(args.exclude)

    report: list[dict] = []
    failures = 0
    for group in common_groups:
        base_draws = read_draws(baseline_groups[group])
        cand_draws = read_draws(candidate_groups[group])
        common_columns = sorted((set(base_draws) & set(cand_draws)) - excluded)
        worst_mean = 0.0
        worst_sd = 0.0
        failed_columns: list[str] = []
        for column in common_columns:
            base_summary = summarize(base_draws[column])
            cand_summary = summarize(cand_draws[column])
            mean_ok = within_tolerance(base_summary["mean"], cand_summary["mean"], args.atol, args.rtol)
            sd_ok = within_tolerance(base_summary["sd"], cand_summary["sd"], args.atol, args.rtol)
            worst_mean = max(worst_mean, abs(base_summary["mean"] - cand_summary["mean"]))
            worst_sd = max(worst_sd, abs(base_summary["sd"] - cand_summary["sd"]))
            if not mean_ok or not sd_ok:
                failed_columns.append(column)
        status = "same" if not failed_columns else "different"
        if failed_columns:
            failures += 1
        row = {
            "model": group,
            "status": status,
            "columns_compared": len(common_columns),
            "failed_columns": failed_columns[:20],
            "max_abs_mean_diff": worst_mean,
            "max_abs_sd_diff": worst_sd,
        }
        report.append(row)
        print(
            f"{group}: {status} "
            f"(columns={len(common_columns)}, max_mean_diff={worst_mean:.6g}, max_sd_diff={worst_sd:.6g})"
        )

    missing_baseline = sorted(set(candidate_groups) - set(baseline_groups))
    missing_candidate = sorted(set(baseline_groups) - set(candidate_groups))
    if missing_baseline:
        print(f"Only in candidate: {', '.join(missing_baseline)}")
    if missing_candidate:
        print(f"Only in baseline: {', '.join(missing_candidate)}")

    if args.json_output:
        output_path = Path(args.json_output).expanduser().resolve()
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with output_path.open("w", encoding="utf-8") as handle:
            json.dump(
                {
                    "baseline": str(baseline),
                    "candidate": str(candidate),
                    "atol": args.atol,
                    "rtol": args.rtol,
                    "models": report,
                    "only_in_baseline": missing_candidate,
                    "only_in_candidate": missing_baseline,
                },
                handle,
                indent=2,
            )
            handle.write("\n")
    return 1 if failures or missing_baseline or missing_candidate else 0


if __name__ == "__main__":
    raise SystemExit(main())
