#!/usr/bin/env python3
"""Run original Stan and SafeStan translations and compare posterior summaries."""

from __future__ import annotations

import argparse
import csv
import json
import math
import os
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from statistics import mean, stdev
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SUMMARY = ROOT / "runs_metadata" / "openai_safestan_generation_models_safe_full45.json"
DEFAULT_SAFE_ROOT = ROOT / "models_safe"
DEFAULT_OUTPUT_ROOT = ROOT / "comparison_runs"
RUNNER = ROOT / "scripts" / "run_cmdstan_model.py"

SAMPLER_COLUMNS = {
    "lp__",
    "accept_stat__",
    "stepsize__",
    "treedepth__",
    "n_leapfrog__",
    "divergent__",
    "energy__",
}


def utc_run_id() -> str:
    return datetime.now(timezone.utc).strftime("comparison-%Y%m%dT%H%M%SZ")


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=2, sort_keys=True)
        handle.write("\n")


def default_cmdstan() -> Path | None:
    for env_name in ("CMDSAFESTAN", "CMDSTAN"):
        value = os.environ.get(env_name)
        if value:
            return Path(value).expanduser().resolve()
    return None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--summary", default=str(DEFAULT_SUMMARY), help="OpenAI SafeStan generation summary JSON.")
    parser.add_argument("--safe-root", default=str(DEFAULT_SAFE_ROOT), help="Mirrored SafeStan output root.")
    parser.add_argument("--output-root", default=str(DEFAULT_OUTPUT_ROOT), help="Directory for comparison runs.")
    parser.add_argument("--run-id", default=utc_run_id(), help="Comparison run id under --output-root.")
    parser.add_argument("--cmdstan", help="CmdStan/cmdsafestan root. Defaults to CMDSAFESTAN or CMDSTAN.")
    parser.add_argument("--only", action="append", default=[], help="Model path, id, or suffix to compare. Repeatable.")
    parser.add_argument("--limit", type=int, help="Compare at most this many selected models.")
    parser.add_argument("--chains", type=int, default=1)
    parser.add_argument("--iter-warmup", type=int, default=200)
    parser.add_argument("--iter-sampling", type=int, default=200)
    parser.add_argument("--seed", type=int, default=12345)
    parser.add_argument("--refresh", type=int, default=0)
    parser.add_argument("--timeout", type=int, default=1800, help="Per original/safe runner timeout in seconds.")
    parser.add_argument("--force-recompile", action="store_true")
    parser.add_argument("--no-compile", action="store_true")
    parser.add_argument("--mean-se-mult", type=float, default=4.0, help="Allowed mean delta in Monte Carlo SE units.")
    parser.add_argument("--mean-abs-tol", type=float, default=0.05, help="Minimum absolute tolerance for mean deltas.")
    parser.add_argument("--sd-rel-tol", type=float, default=0.50, help="Relative tolerance for posterior SD deltas.")
    parser.add_argument("--sd-abs-tol", type=float, default=0.05, help="Minimum absolute tolerance for posterior SD deltas.")
    parser.add_argument("--log-prob-checks", type=int, default=3, help="Number of Stan draws to spot-check with both models' log_prob method.")
    parser.add_argument("--log-prob-tol", type=float, default=1e-6, help="Absolute tolerance for log_prob/gradient spot checks.")
    parser.add_argument("--include-lp", action="store_true", help="Include lp__ in the summary comparison.")
    parser.add_argument("--include-rep", action="store_true", help="Include posterior predictive RNG columns named *_rep.")
    parser.add_argument("--dry-run", action="store_true", help="Print runner commands without executing them.")
    return parser.parse_args()


def selected_records(summary: dict[str, Any], only: list[str], limit: int | None) -> list[dict[str, Any]]:
    records = [
        record
        for record in summary.get("results", [])
        if record.get("compatibility") in {"as-is", "minor"}
        and (Path(record["safe_dir"]) / "model_safe.stan").exists()
        and (Path(record["safe_dir"]) / "data_safe.json").exists()
    ]
    if only:
        needles = [item.strip("/") for item in only]

        def matches(record: dict[str, Any]) -> bool:
            path = record["path"].strip("/")
            name = Path(path).name
            return any(path == needle or path.endswith("/" + needle) or name == needle for needle in needles)

        records = [record for record in records if matches(record)]
    if limit is not None:
        records = records[:limit]
    return records


def copy_if_exists(src: Path, dst: Path) -> None:
    if src.exists():
        shutil.copy2(src, dst)


def prepare_workdirs(record: dict[str, Any], case_dir: Path) -> tuple[Path, Path]:
    model_dir = ROOT / record["path"]
    safe_dir = ROOT / record["safe_dir"]
    stan_work = case_dir / "stan"
    safe_work = case_dir / "safestan"
    stan_work.mkdir(parents=True, exist_ok=True)
    safe_work.mkdir(parents=True, exist_ok=True)

    for filename in ("model.stan", "data.json", "metadata.json", "init.json"):
        copy_if_exists(model_dir / filename, stan_work / filename)
    copy_if_exists(safe_dir / "model_safe.stan", safe_work / "model_safe.stan")
    copy_if_exists(safe_dir / "data_safe.json", safe_work / "data_safe.json")
    copy_if_exists(model_dir / "metadata.json", safe_work / "metadata.json")
    copy_if_exists(model_dir / "init.json", safe_work / "init.json")
    return stan_work, safe_work


def runner_command(
    *,
    model_dir: Path,
    output_dir: Path,
    cmdstan: Path | None,
    args: argparse.Namespace,
    safe: bool,
    protected_variables: list[str],
) -> list[str]:
    command = [
        sys.executable,
        str(RUNNER),
        "--model-dir",
        str(model_dir),
        "--output-dir",
        str(output_dir),
        "--chains",
        str(args.chains),
        "--iter-warmup",
        str(args.iter_warmup),
        "--iter-sampling",
        str(args.iter_sampling),
        "--seed",
        str(args.seed),
        "--refresh",
        str(args.refresh),
    ]
    if cmdstan is not None:
        command.extend(["--cmdstan", str(cmdstan)])
    if args.force_recompile:
        command.append("--force-recompile")
    if args.no_compile:
        command.append("--no-compile")
    if safe:
        command.append("--safe")
        command.extend(["--sstan-protect", ",".join(protected_variables)])
    if args.dry_run:
        command.append("--dry-run")
    return command


def run_runner(command: list[str], log_dir: Path, timeout: int, dry_run: bool) -> dict[str, Any]:
    log_dir.mkdir(parents=True, exist_ok=True)
    write_json(log_dir / "runner_command.json", command)
    if dry_run:
        return {"returncode": 0, "timed_out": False, "command": command}
    try:
        completed = subprocess.run(
            command,
            cwd=ROOT,
            text=True,
            capture_output=True,
            timeout=timeout,
        )
    except subprocess.TimeoutExpired as exc:
        (log_dir / "runner_stdout.txt").write_text(exc.stdout or "", encoding="utf-8")
        (log_dir / "runner_stderr.txt").write_text(exc.stderr or "", encoding="utf-8")
        return {"returncode": None, "timed_out": True, "command": command}
    (log_dir / "runner_stdout.txt").write_text(completed.stdout, encoding="utf-8")
    (log_dir / "runner_stderr.txt").write_text(completed.stderr, encoding="utf-8")
    return {"returncode": completed.returncode, "timed_out": False, "command": command}


def csv_paths(output_dir: Path) -> list[Path]:
    chain_paths = sorted(output_dir.glob("chain-*.csv"))
    if chain_paths:
        return chain_paths
    optimize_path = output_dir / "optimize.csv"
    return [optimize_path] if optimize_path.exists() else []


def read_cmdstan_csvs(output_dir: Path) -> tuple[list[str], list[list[float]]]:
    headers: list[str] | None = None
    rows: list[list[float]] = []
    for path in csv_paths(output_dir):
        with path.open("r", encoding="utf-8", newline="") as handle:
            for raw_line in handle:
                line = raw_line.strip()
                if not line or line.startswith("#"):
                    continue
                parts = next(csv.reader([line]))
                if headers is None:
                    headers = parts
                    continue
                if parts == headers:
                    continue
                if len(parts) != len(headers):
                    continue
                try:
                    row = [float(item) for item in parts]
                except ValueError:
                    continue
                rows.append(row)
    if headers is None:
        raise ValueError(f"No CmdStan CSV header found in {output_dir}")
    if not rows:
        raise ValueError(f"No numeric CmdStan draws found in {output_dir}")
    return headers, rows


def read_single_row_csv(path: Path) -> tuple[list[str], list[float]]:
    headers: list[str] | None = None
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        parts = next(csv.reader([line]))
        if headers is None:
            headers = parts
            continue
        if parts == headers:
            continue
        return headers, [float(item) for item in parts]
    raise ValueError(f"No numeric row found in {path}")


def base_name(column: str) -> str:
    return column.split(".", 1)[0]


def comparable_columns(headers: list[str], include_lp: bool, include_rep: bool) -> list[str]:
    columns = []
    for column in headers:
        if column in SAMPLER_COLUMNS and not (include_lp and column == "lp__"):
            continue
        if base_name(column).endswith("_rep") and not include_rep:
            continue
        columns.append(column)
    return columns


def column_stats(headers: list[str], rows: list[list[float]], columns: list[str]) -> dict[str, dict[str, float]]:
    index = {name: idx for idx, name in enumerate(headers)}
    stats: dict[str, dict[str, float]] = {}
    for column in columns:
        values = [row[index[column]] for row in rows]
        finite = [value for value in values if math.isfinite(value)]
        if len(finite) != len(values):
            stats[column] = {"n": len(values), "finite": 0, "mean": math.nan, "sd": math.nan}
            continue
        stats[column] = {
            "n": len(values),
            "finite": len(values),
            "mean": mean(values),
            "sd": stdev(values) if len(values) > 1 else 0.0,
        }
    return stats


def compare_stats(
    stan_stats: dict[str, dict[str, float]],
    safe_stats: dict[str, dict[str, float]],
    args: argparse.Namespace,
) -> tuple[str, list[dict[str, Any]], dict[str, float]]:
    failures: list[dict[str, Any]] = []
    max_abs_mean_delta = 0.0
    max_mean_z = 0.0
    max_abs_sd_delta = 0.0
    for column in sorted(stan_stats):
        left = stan_stats[column]
        right = safe_stats[column]
        mean_delta = right["mean"] - left["mean"]
        sd_delta = right["sd"] - left["sd"]
        se_delta = math.sqrt((left["sd"] ** 2) / left["n"] + (right["sd"] ** 2) / right["n"])
        mean_threshold = max(args.mean_abs_tol, args.mean_se_mult * se_delta)
        sd_threshold = args.sd_abs_tol + args.sd_rel_tol * max(left["sd"], right["sd"], 1e-12)
        mean_ok = math.isfinite(mean_delta) and abs(mean_delta) <= mean_threshold
        sd_ok = math.isfinite(sd_delta) and abs(sd_delta) <= sd_threshold
        mean_z = abs(mean_delta) / se_delta if se_delta > 0 else (0.0 if mean_delta == 0 else math.inf)
        max_abs_mean_delta = max(max_abs_mean_delta, abs(mean_delta))
        max_mean_z = max(max_mean_z, mean_z)
        max_abs_sd_delta = max(max_abs_sd_delta, abs(sd_delta))
        if not (mean_ok and sd_ok):
            failures.append(
                {
                    "column": column,
                    "stan_mean": left["mean"],
                    "safe_mean": right["mean"],
                    "mean_delta": mean_delta,
                    "mean_threshold": mean_threshold,
                    "mean_z": mean_z,
                    "stan_sd": left["sd"],
                    "safe_sd": right["sd"],
                    "sd_delta": sd_delta,
                    "sd_threshold": sd_threshold,
                    "mean_ok": mean_ok,
                    "sd_ok": sd_ok,
                }
            )
    status = "same" if not failures else "different"
    metrics = {
        "max_abs_mean_delta": max_abs_mean_delta,
        "max_mean_z": max_mean_z,
        "max_abs_sd_delta": max_abs_sd_delta,
        "failed_columns": len(failures),
    }
    return status, failures, metrics


def compare_outputs(stan_output: Path, safe_output: Path, args: argparse.Namespace) -> dict[str, Any]:
    stan_headers, stan_rows = read_cmdstan_csvs(stan_output)
    safe_headers, safe_rows = read_cmdstan_csvs(safe_output)
    stan_columns = set(comparable_columns(stan_headers, args.include_lp, args.include_rep))
    safe_columns = set(comparable_columns(safe_headers, args.include_lp, args.include_rep))
    common = sorted(stan_columns & safe_columns)
    missing_in_safe = sorted(stan_columns - safe_columns)
    extra_in_safe = sorted(safe_columns - stan_columns)
    if not common:
        return {
            "status": "different",
            "reason": "no common comparable columns",
            "stan_draws": len(stan_rows),
            "safe_draws": len(safe_rows),
            "missing_in_safe": missing_in_safe,
            "extra_in_safe": extra_in_safe,
        }
    stan_stats = column_stats(stan_headers, stan_rows, common)
    safe_stats = column_stats(safe_headers, safe_rows, common)
    status, failures, metrics = compare_stats(stan_stats, safe_stats, args)
    return {
        "status": status,
        "stan_draws": len(stan_rows),
        "safe_draws": len(safe_rows),
        "compared_columns": len(common),
        "missing_in_safe": missing_in_safe,
        "extra_in_safe": extra_in_safe,
        "failures": failures[:20],
        "metrics": metrics,
    }


def build_nested_array(values: dict[tuple[int, ...], float]) -> Any:
    rank = len(next(iter(values)))
    dims = [max(index[dim] for index in values) for dim in range(rank)]

    def build(prefix: tuple[int, ...]) -> Any:
        if len(prefix) == rank:
            return values[prefix]
        dim = len(prefix)
        return [build(prefix + (idx,)) for idx in range(1, dims[dim] + 1)]

    return build(())


def draw_to_constrained_json(headers: list[str], row: list[float]) -> dict[str, Any]:
    payload: dict[str, Any] = {}
    arrays: dict[str, dict[tuple[int, ...], float]] = {}
    for column, value in zip(headers, row):
        if column in SAMPLER_COLUMNS or not math.isfinite(value):
            continue
        parts = column.split(".")
        if len(parts) == 1:
            payload[column] = value
            continue
        try:
            index = tuple(int(part) for part in parts[1:])
        except ValueError:
            continue
        arrays.setdefault(parts[0], {})[index] = value
    for name, values in arrays.items():
        payload[name] = build_nested_array(values)
    return payload


def parse_log_prob_csv(path: Path) -> dict[str, float]:
    headers, row = read_single_row_csv(path)
    return {name: value for name, value in zip(headers, row)}


def run_log_prob(
    *,
    exe: Path,
    data_file: Path,
    params_file: Path,
    output_file: Path,
    log_file: Path,
    timeout: int,
) -> dict[str, Any]:
    command = [
        str(exe),
        "log_prob",
        f"constrained_params={params_file}",
        "propto=1",
        "jacobian=1",
        "data",
        f"file={data_file}",
        "output",
        f"file={output_file}",
        "sig_figs=18",
        "refresh=0",
    ]
    try:
        completed = subprocess.run(command, cwd=ROOT, text=True, capture_output=True, timeout=timeout)
    except subprocess.TimeoutExpired as exc:
        log_file.write_text((exc.stdout or "") + "\n" + (exc.stderr or ""), encoding="utf-8")
        return {"returncode": None, "timed_out": True, "command": command}
    log_file.write_text(completed.stdout + "\n" + completed.stderr, encoding="utf-8")
    return {"returncode": completed.returncode, "timed_out": False, "command": command}


def compare_log_prob(
    *,
    stan_work: Path,
    safe_work: Path,
    stan_output: Path,
    args: argparse.Namespace,
) -> dict[str, Any]:
    if args.log_prob_checks <= 0:
        return {"status": "skipped", "checks": 0}

    headers, rows = read_cmdstan_csvs(stan_output)
    log_dir = safe_work.parent / "log_prob"
    log_dir.mkdir(parents=True, exist_ok=True)
    checks = []
    max_abs_delta = 0.0
    max_failed_columns = 0
    for index, row in enumerate(rows[: args.log_prob_checks], start=1):
        params_file = log_dir / f"params-{index}.json"
        params_file.write_text(json.dumps(draw_to_constrained_json(headers, row), separators=(",", ":")), encoding="utf-8")
        stan_csv = log_dir / f"stan-log-prob-{index}.csv"
        safe_csv = log_dir / f"safestan-log-prob-{index}.csv"
        stan_run = run_log_prob(
            exe=stan_work / "model",
            data_file=stan_work / "data.json",
            params_file=params_file,
            output_file=stan_csv,
            log_file=log_dir / f"stan-log-prob-{index}.log",
            timeout=args.timeout,
        )
        safe_run = run_log_prob(
            exe=safe_work / "model_safe",
            data_file=safe_work / "data_safe.json",
            params_file=params_file,
            output_file=safe_csv,
            log_file=log_dir / f"safestan-log-prob-{index}.log",
            timeout=args.timeout,
        )
        if stan_run["returncode"] != 0 or safe_run["returncode"] != 0:
            checks.append({"index": index, "status": "run-failed", "stan_run": stan_run, "safe_run": safe_run})
            max_failed_columns += 1
            continue
        stan_lp = parse_log_prob_csv(stan_csv)
        safe_lp = parse_log_prob_csv(safe_csv)
        common = sorted(set(stan_lp) & set(safe_lp))
        failures = []
        for column in common:
            delta = safe_lp[column] - stan_lp[column]
            max_abs_delta = max(max_abs_delta, abs(delta))
            if abs(delta) > args.log_prob_tol:
                failures.append({"column": column, "stan": stan_lp[column], "safe": safe_lp[column], "delta": delta})
        max_failed_columns = max(max_failed_columns, len(failures))
        checks.append(
            {
                "index": index,
                "status": "same" if not failures else "different",
                "compared_columns": len(common),
                "failures": failures[:20],
                "stan_run": stan_run,
                "safe_run": safe_run,
            }
        )
    status = "same" if all(check["status"] == "same" for check in checks) else "different"
    return {
        "status": status,
        "checks": len(checks),
        "max_abs_delta": max_abs_delta,
        "max_failed_columns": max_failed_columns,
        "artifact_dir": str(log_dir.relative_to(ROOT)),
        "details": checks,
    }


def combined_status(posterior_status: str, log_prob_status: str) -> str:
    if posterior_status == "same" and log_prob_status in {"same", "skipped"}:
        return "same"
    if log_prob_status == "same":
        return "same-density-mcmc-different"
    return posterior_status


def compare_one(record: dict[str, Any], output_root: Path, cmdstan: Path | None, args: argparse.Namespace) -> dict[str, Any]:
    rel = Path(record["path"]).relative_to("models")
    case_dir = output_root / rel
    if case_dir.exists():
        shutil.rmtree(case_dir)
    stan_work, safe_work = prepare_workdirs(record, case_dir)
    stan_output = stan_work / "run"
    safe_output = safe_work / "run"

    protected = [str(item) for item in record.get("protected_variables", [])]
    stan_command = runner_command(
        model_dir=stan_work,
        output_dir=stan_output,
        cmdstan=cmdstan,
        args=args,
        safe=False,
        protected_variables=[],
    )
    safe_command = runner_command(
        model_dir=safe_work,
        output_dir=safe_output,
        cmdstan=cmdstan,
        args=args,
        safe=True,
        protected_variables=protected,
    )

    stan_run = run_runner(stan_command, stan_work / "logs", args.timeout, args.dry_run)
    if stan_run["returncode"] != 0:
        return {
            "path": record["path"],
            "compatibility": record["compatibility"],
            "status": "run-failed",
            "failed_side": "stan",
            "stan_run": stan_run,
            "safe_run": None,
            "case_dir": str(case_dir.relative_to(ROOT)),
        }

    safe_run = run_runner(safe_command, safe_work / "logs", args.timeout, args.dry_run)
    if safe_run["returncode"] != 0:
        return {
            "path": record["path"],
            "compatibility": record["compatibility"],
            "status": "run-failed",
            "failed_side": "safestan",
            "stan_run": stan_run,
            "safe_run": safe_run,
            "case_dir": str(case_dir.relative_to(ROOT)),
        }

    if args.dry_run:
        comparison = {"status": "dry-run"}
        log_prob = {"status": "skipped", "checks": 0}
    else:
        comparison = compare_outputs(stan_output, safe_output, args)
        log_prob = compare_log_prob(stan_work=stan_work, safe_work=safe_work, stan_output=stan_output, args=args)
    status = comparison["status"] if args.dry_run else combined_status(comparison["status"], log_prob["status"])
    return {
        "path": record["path"],
        "compatibility": record["compatibility"],
        "protected_variables": protected,
        "status": status,
        "comparison": comparison,
        "log_prob": log_prob,
        "stan_run": stan_run,
        "safe_run": safe_run,
        "case_dir": str(case_dir.relative_to(ROOT)),
    }


def write_markdown(path: Path, payload: dict[str, Any]) -> None:
    rows = payload["results"]
    counts: dict[str, int] = {}
    for row in rows:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
    lines = [
        "# Stan vs SafeStan Result Comparison",
        "",
        f"Run id: `{payload['run_id']}`",
        "",
        f"Compared `{len(rows)}` generated SafeStan models.",
        "",
        "| Status | Count |",
        "|---|---:|",
    ]
    for status in sorted(counts):
        lines.append(f"| `{status}` | {counts[status]} |")
    lines.extend(
        [
            "",
            "| Model | Compatibility | Status | Draws | Columns | Max mean z | Failed columns | Artifacts |",
            "|---|---:|---:|---:|---:|---:|---:|---|",
        ]
    )
    for row in rows:
        comparison = row.get("comparison") or {}
        log_prob = row.get("log_prob") or {}
        metrics = comparison.get("metrics") or {}
        draws = comparison.get("stan_draws", "")
        columns = comparison.get("compared_columns", "")
        max_mean_z = metrics.get("max_mean_z", "")
        if isinstance(max_mean_z, float):
            max_mean_z = f"{max_mean_z:.3f}"
        failed = metrics.get("failed_columns", "")
        if row["status"] == "same-density-mcmc-different":
            failed = f"{failed}; log_prob={log_prob.get('status')}"
        lines.append(
            f"| [{Path(row['path']).name}]({row['path']}/) | {row['compatibility']} | {row['status']} | "
            f"{draws} | {columns} | {max_mean_z} | {failed} | [{row['case_dir']}]({row['case_dir']}/) |"
        )
    lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    args = parse_args()
    summary = load_json(Path(args.summary).expanduser().resolve())
    cmdstan = Path(args.cmdstan).expanduser().resolve() if args.cmdstan else default_cmdstan()
    if cmdstan is None and not args.dry_run:
        raise SystemExit("Pass --cmdstan or set CMDSAFESTAN/CMDSTAN.")

    records = selected_records(summary, args.only, args.limit)
    output_root = Path(args.output_root).expanduser().resolve() / args.run_id
    output_root.mkdir(parents=True, exist_ok=True)

    results = []
    for index, record in enumerate(records, start=1):
        print(f"[{index}/{len(records)}] {record['path']}", flush=True)
        result = compare_one(record, output_root, cmdstan, args)
        results.append(result)
        print(f"  {result['status']}", flush=True)

    payload = {
        "run_id": args.run_id,
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "summary": str(Path(args.summary)),
        "cmdstan": str(cmdstan) if cmdstan else None,
        "settings": {
            "chains": args.chains,
            "iter_warmup": args.iter_warmup,
            "iter_sampling": args.iter_sampling,
            "seed": args.seed,
            "mean_se_mult": args.mean_se_mult,
            "mean_abs_tol": args.mean_abs_tol,
            "sd_rel_tol": args.sd_rel_tol,
            "sd_abs_tol": args.sd_abs_tol,
            "log_prob_checks": args.log_prob_checks,
            "log_prob_tol": args.log_prob_tol,
            "include_lp": args.include_lp,
            "include_rep": args.include_rep,
        },
        "results": results,
    }
    write_json(output_root / "comparison_results.json", payload)
    write_markdown(output_root / "COMPARISON_RESULTS.md", payload)
    print(f"Wrote {output_root / 'comparison_results.json'}", flush=True)
    successful_statuses = {"same", "same-density-mcmc-different", "dry-run"}
    return 0 if all(row["status"] in successful_statuses for row in results) else 1


if __name__ == "__main__":
    raise SystemExit(main())
