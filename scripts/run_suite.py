#!/usr/bin/env python3
"""Run a selected subset of the model corpus."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def timestamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", default=str(ROOT / "model_manifest.json"))
    parser.add_argument("--source", action="append", help="Filter by source_group, e.g. forestdb.")
    parser.add_argument("--difficulty", action="append", help="Filter by difficulty.")
    parser.add_argument("--model", action="append", help="Filter by model id; repeatable.")
    parser.add_argument("--limit", type=int, help="Maximum number of models to run after filtering.")
    parser.add_argument("--cmdstan", help="CmdStan/cmdsafestan root directory.")
    parser.add_argument("--make-command", default="make")
    parser.add_argument("--stan-file", help="Use this Stan/SafeStan filename in every model directory.")
    parser.add_argument("--output-root", default=str(ROOT / "runs" / f"suite-{timestamp()}"))
    parser.add_argument("--chains", type=int)
    parser.add_argument("--iter-warmup", type=int)
    parser.add_argument("--iter-sampling", type=int)
    parser.add_argument("--seed", type=int)
    parser.add_argument("--refresh", type=int)
    parser.add_argument("--no-compile", action="store_true")
    parser.add_argument("--force-recompile", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--continue-on-error", action="store_true")
    parser.add_argument("--extra-arg", action="append", default=[])
    return parser.parse_args()


def selected_models(manifest_path: Path, args: argparse.Namespace) -> list[dict]:
    with manifest_path.open("r", encoding="utf-8") as handle:
        manifest = json.load(handle)
    models = manifest["models"]
    if args.source:
        allowed = set(args.source)
        models = [m for m in models if m["source_group"] in allowed]
    if args.difficulty:
        allowed = set(args.difficulty)
        models = [m for m in models if m["difficulty"] in allowed]
    if args.model:
        allowed = set(args.model)
        models = [m for m in models if m["id"] in allowed]
    if args.limit is not None:
        models = models[: args.limit]
    return models


def append_option(cmd: list[str], name: str, value: object | None) -> None:
    if value is not None:
        cmd.extend([name, str(value)])


def main() -> int:
    args = parse_args()
    manifest_path = Path(args.manifest).expanduser().resolve()
    models = selected_models(manifest_path, args)
    output_root = Path(args.output_root).expanduser().resolve()
    if not args.dry_run:
        output_root.mkdir(parents=True, exist_ok=True)

    runner = ROOT / "scripts" / "run_cmdstan_model.py"
    failures: list[tuple[str, int]] = []
    for model in models:
        model_dir = ROOT / model["path"]
        model_output = output_root / model["source_group"] / model["id"]
        cmd = [sys.executable, str(runner), "--model-dir", str(model_dir), "--output-dir", str(model_output)]
        append_option(cmd, "--cmdstan", args.cmdstan)
        append_option(cmd, "--make-command", args.make_command)
        append_option(cmd, "--stan-file", args.stan_file)
        append_option(cmd, "--chains", args.chains)
        append_option(cmd, "--iter-warmup", args.iter_warmup)
        append_option(cmd, "--iter-sampling", args.iter_sampling)
        append_option(cmd, "--seed", args.seed)
        append_option(cmd, "--refresh", args.refresh)
        if args.no_compile:
            cmd.append("--no-compile")
        if args.force_recompile:
            cmd.append("--force-recompile")
        if args.dry_run:
            cmd.append("--dry-run")
        for extra_arg in args.extra_arg:
            cmd.extend(["--extra-arg", extra_arg])

        print(f"\n# {model['id']}", flush=True)
        rc = subprocess.run(cmd).returncode
        if rc != 0:
            failures.append((model["id"], rc))
            if not args.continue_on_error:
                break

    if failures:
        print("\nFailures:")
        for model_id, rc in failures:
            print(f"  {model_id}: {rc}")
        return failures[0][1]
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
