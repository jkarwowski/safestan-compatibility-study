#!/usr/bin/env python3
"""Run one model directory through a CmdStan-compatible toolchain.

The runner assumes each model directory contains `model.stan` and `data.json`.
It is intentionally shell-level and does not depend on cmdstanpy, so it can be
used with CmdStan replacements such as cmdsafestan.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
MODELS_ROOT = ROOT / "models"
DEFAULT_SAFE_ROOT = ROOT / "models_safe"


def load_json(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def default_cmdstan() -> Path | None:
    for env_name in ("CMDSAFESTAN", "CMDSTAN"):
        value = os.environ.get(env_name)
        if value:
            return Path(value).expanduser().resolve()
    return None


def timestamp() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def run_command(cmd: list[str], cwd: Path | None, dry_run: bool) -> int:
    printable = " ".join(cmd)
    if cwd is not None:
        printable = f"(cd {cwd} && {printable})"
    print(printable)
    if dry_run:
        return 0
    return subprocess.run(cmd, cwd=str(cwd) if cwd else None).returncode


def model_executable_for(stan_file: Path) -> Path:
    return stan_file.with_suffix("")


def split_protected_variables(value: str) -> list[str]:
    return [item.strip() for item in value.split(",") if item.strip()]


def safe_dir_for_model(model_dir: Path, safe_root: Path) -> Path:
    try:
        relative = model_dir.relative_to(MODELS_ROOT)
    except ValueError:
        return model_dir
    return (safe_root / relative).resolve()


def load_protected_variables(safe_model_dir: Path, override: str | None) -> list[str]:
    if override:
        return split_protected_variables(override)

    for path in (safe_model_dir / "api" / "translation.json", safe_model_dir / "api" / "record.json"):
        payload = load_json(path)
        protected = payload.get("protected_variables")
        if isinstance(protected, list):
            return [str(item) for item in protected if str(item)]

    return []


def cmdsafestan_command_for(cmdstan: Path | None, dry_run: bool) -> tuple[list[str], Path | None]:
    if cmdstan is None:
        if dry_run:
            return ["cmdsafestan"], None
        raise SystemExit(
            "No cmdsafestan directory provided. Pass --cmdstan or set CMDSAFESTAN, "
            "or use --no-compile with an existing executable."
        )

    if cmdstan.is_file():
        return [str(cmdstan)], cmdstan.parent

    command = cmdstan / "cmdsafestan"
    if not dry_run and not command.exists():
        raise SystemExit(f"cmdsafestan wrapper does not exist: {command}")
    return [str(command)], cmdstan


def compile_model(
    *,
    stan_file: Path,
    cmdstan: Path | None,
    make_command: str,
    force_recompile: bool,
    dry_run: bool,
) -> tuple[Path, int]:
    exe = model_executable_for(stan_file)
    if exe.exists() and not force_recompile:
        return exe, 0
    if cmdstan is None and dry_run:
        return exe, run_command([make_command, str(exe)], cwd=None, dry_run=True)
    if cmdstan is None:
        raise SystemExit(
            "No CmdStan-compatible directory provided. Pass --cmdstan or set "
            "CMDSAFESTAN/CMDSTAN, or use --no-compile with an existing executable."
        )
    if not dry_run and not cmdstan.exists():
        raise SystemExit(f"CmdStan-compatible directory does not exist: {cmdstan}")
    return exe, run_command([make_command, str(exe)], cwd=cmdstan, dry_run=dry_run)


def compile_safestan_model(
    *,
    stan_file: Path,
    cmdstan: Path | None,
    protected_variables: list[str],
    force_recompile: bool,
    dry_run: bool,
) -> tuple[Path, int]:
    exe = model_executable_for(stan_file)
    if exe.exists() and not force_recompile:
        return exe, 0
    if not protected_variables:
        raise SystemExit(
            "SafeStan compilation requires protected variables. Pass --sstan-protect "
            "or ensure models_safe/<category>/<model>/api/translation.json contains them."
        )
    command, cwd = cmdsafestan_command_for(cmdstan, dry_run)
    command.extend(["--sstan-protect", ",".join(protected_variables), str(stan_file)])
    return exe, run_command(command, cwd=cwd, dry_run=dry_run)


def sample_commands(
    *,
    exe: Path,
    data_file: Path,
    init_file: Path | None,
    output_dir: Path,
    chains: int,
    iter_warmup: int,
    iter_sampling: int,
    seed: int,
    refresh: int,
    extra_args: list[str],
) -> list[list[str]]:
    commands: list[list[str]] = []
    for chain in range(1, chains + 1):
        csv_path = output_dir / f"chain-{chain}.csv"
        cmd = [str(exe), f"id={chain}"]
        if init_file is not None:
            cmd.append(f"init={init_file}")
        cmd.extend(
            [
                "sample",
                f"num_warmup={iter_warmup}",
                f"num_samples={iter_sampling}",
                "save_warmup=0",
                "data",
                f"file={data_file}",
                "random",
                f"seed={seed}",
                "output",
                f"file={csv_path}",
                f"refresh={refresh}",
            ]
        )
        cmd.extend(extra_args)
        commands.append(cmd)
    return commands


def optimize_command(
    *,
    exe: Path,
    data_file: Path,
    init_file: Path | None,
    output_dir: Path,
    seed: int,
    refresh: int,
    optimize_iter: int,
    extra_args: list[str],
) -> list[str]:
    csv_path = output_dir / "optimize.csv"
    cmd = [str(exe)]
    if init_file is not None:
        cmd.append(f"init={init_file}")
    cmd.extend(
        [
            "optimize",
            "algorithm=lbfgs",
            f"iter={optimize_iter}",
            "data",
            f"file={data_file}",
            "random",
            f"seed={seed}",
            "output",
            f"file={csv_path}",
            f"refresh={refresh}",
        ]
    )
    cmd.extend(extra_args)
    return cmd


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model-dir", default=".", help="Directory containing model.stan and data.json.")
    parser.add_argument("--safe", action="store_true", help="Use model_safe.stan and data_safe.json from models_safe/.")
    parser.add_argument("--safe-root", default=str(DEFAULT_SAFE_ROOT), help="Mirrored root containing SafeStan outputs.")
    parser.add_argument("--sstan-protect", help="Comma-separated protected variables. Defaults to models_safe/.../api/translation.json.")
    parser.add_argument("--stan-file", help="Stan/SafeStan file name or path. Defaults to metadata stan_file or model.stan.")
    parser.add_argument("--data", help="Data JSON file name or path. Defaults to metadata data_file or data.json.")
    parser.add_argument("--init", help="Optional init file. Defaults to init.json if present.")
    parser.add_argument("--cmdstan", help="CmdStan/cmdsafestan root directory. Defaults to CMDSAFESTAN or CMDSTAN.")
    parser.add_argument("--make-command", default="make", help="Build command to run inside --cmdstan.")
    parser.add_argument("--no-compile", action="store_true", help="Skip compilation and run the existing executable.")
    parser.add_argument("--force-recompile", action="store_true", help="Rebuild even if the executable exists.")
    parser.add_argument("--method", choices=("sample", "optimize"), help="Inference method. Defaults to metadata or sample.")
    parser.add_argument("--chains", type=int, help="Number of chains for sample.")
    parser.add_argument("--iter-warmup", type=int, help="Warmup iterations for sample.")
    parser.add_argument("--iter-sampling", type=int, help="Sampling iterations per chain.")
    parser.add_argument("--seed", type=int, help="Base random seed.")
    parser.add_argument("--refresh", type=int, default=100, help="CmdStan refresh interval.")
    parser.add_argument("--optimize-iter", type=int, default=2000, help="Maximum optimizer iterations.")
    parser.add_argument("--output-dir", help="Output directory. Defaults to model-dir/runs/<UTC timestamp>.")
    parser.add_argument("--extra-arg", action="append", default=[], help="Extra raw CmdStan argument; repeatable.")
    parser.add_argument("--dry-run", action="store_true", help="Print commands without executing them.")
    return parser.parse_args(argv)


def resolve_model_file(model_dir: Path, name: str) -> Path:
    path = Path(name)
    return path if path.is_absolute() else (model_dir / path).resolve()


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    model_dir = Path(args.model_dir).expanduser().resolve()
    safe_root = Path(args.safe_root).expanduser().resolve()
    safe_model_dir = safe_dir_for_model(model_dir, safe_root)
    metadata = load_json(model_dir / "metadata.json")
    defaults = metadata.get("default_run", {})

    if args.safe:
        file_base_dir = safe_model_dir
        stan_name = args.stan_file or "model_safe.stan"
        data_name = args.data or "data_safe.json"
        protected_variables = load_protected_variables(safe_model_dir, args.sstan_protect)
    else:
        file_base_dir = model_dir
        stan_name = args.stan_file or metadata.get("stan_file", "model.stan")
        data_name = args.data or metadata.get("data_file", "data.json")
        protected_variables = []
    stan_file = resolve_model_file(file_base_dir, stan_name)
    data_file = resolve_model_file(file_base_dir, data_name)

    if args.init:
        init_file = resolve_model_file(model_dir, args.init)
    else:
        candidate = model_dir / "init.json"
        init_file = candidate.resolve() if candidate.exists() else None

    if not stan_file.exists():
        raise SystemExit(f"Stan file does not exist: {stan_file}")
    if not data_file.exists():
        raise SystemExit(f"Data file does not exist: {data_file}")

    cmdstan = Path(args.cmdstan).expanduser().resolve() if args.cmdstan else default_cmdstan()
    method = args.method or metadata.get("method", "sample")
    chains = args.chains or int(defaults.get("chains", 4))
    iter_warmup = args.iter_warmup or int(defaults.get("iter_warmup", 250))
    iter_sampling = args.iter_sampling or int(defaults.get("iter_sampling", 250))
    seed = args.seed or int(defaults.get("seed", 12345))

    output_base_dir = safe_model_dir if args.safe else model_dir
    output_dir = Path(args.output_dir).expanduser() if args.output_dir else output_base_dir / "runs" / timestamp()
    output_dir = output_dir.resolve()
    if not args.dry_run:
        output_dir.mkdir(parents=True, exist_ok=True)

    compile_returncode = 0
    exe = model_executable_for(stan_file)
    if not args.no_compile:
        if args.safe:
            exe, compile_returncode = compile_safestan_model(
                stan_file=stan_file,
                cmdstan=cmdstan,
                protected_variables=protected_variables,
                force_recompile=args.force_recompile,
                dry_run=args.dry_run,
            )
        else:
            exe, compile_returncode = compile_model(
                stan_file=stan_file,
                cmdstan=cmdstan,
                make_command=args.make_command,
                force_recompile=args.force_recompile,
                dry_run=args.dry_run,
            )
        if compile_returncode != 0:
            return compile_returncode
    elif not exe.exists() and not args.dry_run:
        raise SystemExit(f"Executable does not exist and --no-compile was passed: {exe}")

    if method == "sample":
        commands = sample_commands(
            exe=exe,
            data_file=data_file,
            init_file=init_file,
            output_dir=output_dir,
            chains=chains,
            iter_warmup=iter_warmup,
            iter_sampling=iter_sampling,
            seed=seed,
            refresh=args.refresh,
            extra_args=args.extra_arg,
        )
    else:
        commands = [
            optimize_command(
                exe=exe,
                data_file=data_file,
                init_file=init_file,
                output_dir=output_dir,
                seed=seed,
                refresh=args.refresh,
                optimize_iter=args.optimize_iter,
                extra_args=args.extra_arg,
            )
        ]

    command_results = []
    returncode = 0
    for command in commands:
        rc = run_command(command, cwd=None, dry_run=args.dry_run)
        command_results.append({"command": command, "returncode": rc})
        if rc != 0:
            returncode = rc
            break

    run_record = {
        "model_dir": str(model_dir),
        "safe_model_dir": str(safe_model_dir) if args.safe else None,
        "stan_file": str(stan_file),
        "data_file": str(data_file),
        "init_file": str(init_file) if init_file else None,
        "cmdstan": str(cmdstan) if cmdstan else None,
        "protected_variables": protected_variables,
        "method": method,
        "compile_returncode": compile_returncode,
        "commands": command_results,
    }
    if not args.dry_run:
        with (output_dir / "run.json").open("w", encoding="utf-8") as handle:
            json.dump(run_record, handle, indent=2)
            handle.write("\n")
    return returncode


if __name__ == "__main__":
    raise SystemExit(main())
