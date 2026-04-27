#!/usr/bin/env python3
"""Materialize every Stan file from stan-dev/example-models.

This creates a separate expanded corpus under models_all/ and does not replace
the curated 45-model corpus under models/. Every materialized model gets a
data.json: upstream same-stem JSON when present, otherwise synthetic data from
stanc --debug-generate-data when possible.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import stat
import subprocess
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
GROUP = "stan_example_models_full"
GROUP_LABEL = "Stan example-models full"
DEFAULT_RUN = {"chains": 4, "iter_warmup": 250, "iter_sampling": 250, "seed": 12345}

MANUAL_SYNTHETIC_DATA: dict[str, dict[str, Any]] = {
    "jupyter/sum-to-zero/stan/bym2_multicomp.stan": {
        "N": 4,
        "y": [2, 1, 3, 2],
        "E": [1.0, 1.2, 0.9, 1.1],
        "K": 1,
        "xs": [[-0.5], [0.0], [0.5], [1.0]],
        "N_components": 1,
        "component_sizes": [4],
        "scaling_factors": [1.0],
        "N_edges": 3,
        "neighbors": [[1, 2, 3], [2, 3, 4]],
    },
    "jupyter/sum-to-zero/stan/bym2_multicomp_soft.stan": {
        "N": 4,
        "y": [2, 1, 3, 2],
        "E": [1.0, 1.2, 0.9, 1.1],
        "K": 1,
        "xs": [[-0.5], [0.0], [0.5], [1.0]],
        "N_components": 1,
        "component_sizes": [4],
        "N_edges": 3,
        "neighbors": [[1, 2, 3], [2, 3, 4]],
        "scaling_factors": [1.0],
    },
    "misc/ecology/mark-recapture/mark-recapture-2.stan": {
        "M": 10,
        "C": 8,
        "R": 3,
    },
    "misc/ecology/mark-recapture/mark-recapture-3.stan": {
        "M": 10,
        "C": 8,
        "R": 3,
    },
}


RUN_PY = """#!/usr/bin/env python3
from pathlib import Path
import sys

HERE = Path(__file__).resolve()
ROOT = next(parent for parent in HERE.parents if (parent / "scripts" / "run_cmdstan_model.py").exists())
sys.path.insert(0, str(ROOT))

from scripts.run_cmdstan_model import main

if __name__ == "__main__":
    raise SystemExit(main(["--model-dir", str(HERE.parent), *sys.argv[1:]]))
"""


def safe_segment(value: str) -> str:
    value = re.sub(r"[^A-Za-z0-9._-]+", "-", value).strip("-")
    return value.lower() or "model"


def title_from_path(path: Path) -> str:
    return re.sub(r"[-_]+", " ", path.stem).strip().title()


def difficulty_for(rel_path: Path, source: str) -> str:
    text = f"{rel_path.as_posix()} {source}".lower()
    if any(token in text for token in ["ode", "gaussian-process", "gp-", "hmm", "irt", "mixture", "bym", "icar", "neural", "covid", "planetary", "laplace"]):
        return "advanced"
    if any(token in text for token in ["hier", "multi", "multivariate", "logit", "regression", "garch", "arma", "survival", "occupancy", "mark-recapture"]):
        return "medium"
    return "easy"


def git_revision(path: Path) -> str:
    result = subprocess.run(["git", "-C", str(path), "rev-parse", "HEAD"], capture_output=True, text=True)
    if result.returncode != 0:
        raise SystemExit(result.stderr.strip())
    return result.stdout.strip()


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2)
        handle.write("\n")


def write_text(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value, encoding="utf-8")


def source_url(commit: str, rel_path: Path) -> str:
    return f"https://github.com/stan-dev/example-models/blob/{commit}/{rel_path.as_posix()}"


def data_json_for(stan_file: Path) -> Path | None:
    candidate = stan_file.with_suffix(".data.json")
    if candidate.exists():
        return candidate
    return None


def find_stanc(explicit: str | None) -> Path | None:
    candidates: list[Path] = []
    if explicit:
        candidates.append(Path(explicit))
    if os.environ.get("SAFESTAN_STANC"):
        candidates.append(Path(os.environ["SAFESTAN_STANC"]))
    candidates.extend(
        [
            ROOT / "safestan" / "_build" / "default" / "src" / "stanc" / "stanc.exe",
            Path("/tmp/cmdsafestan/safestan/_build/default/src/stanc/stanc.exe"),
            Path("/private/tmp/cmdsafestan/safestan/_build/default/src/stanc/stanc.exe"),
        ]
    )
    for candidate in candidates:
        candidate = candidate.expanduser()
        if candidate.is_file() and os.access(candidate, os.X_OK):
            return candidate.resolve()
    return None


def generate_synthetic_data(
    stanc: Path | None,
    stan_file: Path,
    target_path: Path,
    rel_path: Path,
) -> tuple[str, str | None]:
    manual = MANUAL_SYNTHETIC_DATA.get(rel_path.as_posix())
    if manual is not None:
        write_json(target_path, manual)
        return "synthetic", None
    if stanc is None:
        return "unavailable", "SafeStan stanc not found for synthetic data generation."
    result = subprocess.run(
        [str(stanc), "--debug-generate-data", str(stan_file)],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return "unavailable", (result.stderr or result.stdout).strip()
    try:
        data = json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        return "unavailable", f"stanc generated invalid JSON: {exc}"
    write_json(target_path, data)
    return "synthetic", None


def model_id(rel_path: Path) -> str:
    return safe_segment("-".join(rel_path.with_suffix("").parts))


def target_dir_for(rel_path: Path) -> Path:
    return ROOT / "models_all" / "stan_example_models" / Path(*[safe_segment(part) for part in rel_path.with_suffix("").parts])


def materialize_model(examples_root: Path, commit: str, stan_file: Path, stanc: Path | None) -> dict[str, Any]:
    rel_path = stan_file.relative_to(examples_root)
    target_dir = target_dir_for(rel_path)
    if target_dir.exists():
        shutil.rmtree(target_dir)
    target_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(stan_file, target_dir / "model.stan")

    data_path = data_json_for(stan_file)
    data_file: str | None = None
    data_source: str | None = None
    data_status = "unavailable"
    synthetic_data_error: str | None = None
    if data_path is not None:
        shutil.copy2(data_path, target_dir / "data.json")
        data_file = "data.json"
        data_source = data_path.relative_to(examples_root).as_posix()
        data_status = "upstream"
    else:
        data_status, synthetic_data_error = generate_synthetic_data(
            stanc,
            stan_file,
            target_dir / "data.json",
            rel_path,
        )
        if data_status == "synthetic":
            data_file = "data.json"

    source = stan_file.read_text(encoding="utf-8", errors="replace")
    entry = {
        "id": model_id(rel_path),
        "title": title_from_path(rel_path),
        "source_group": GROUP,
        "source_group_label": GROUP_LABEL,
        "difficulty": difficulty_for(rel_path, source),
        "description": f"Stan example-models program `{rel_path.as_posix()}`.",
        "source_url": source_url(commit, rel_path),
        "source_path": rel_path.as_posix(),
        "data_source": data_source,
        "data_status": data_status,
        "synthetic_data_error": synthetic_data_error,
        "path": str(target_dir.relative_to(ROOT)),
        "stan_file": "model.stan",
        "data_file": data_file,
        "method": "sample",
        "default_run": DEFAULT_RUN,
    }
    write_json(target_dir / "metadata.json", entry)
    write_text(
        target_dir / "source.md",
        "\n".join(
            [
                f"# {entry['title']}",
                "",
                f"- Upstream Stan file: [{rel_path.as_posix()}]({entry['source_url']})",
                f"- Upstream data JSON: {data_source or 'none found'}",
                f"- Data used here: {data_status}",
                "- Source group: Stan example-models full",
                "",
            ]
        ),
    )
    run_py = target_dir / "run.py"
    write_text(run_py, RUN_PY)
    run_py.chmod(run_py.stat().st_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
    return entry


def write_expanded_readme(models: list[dict[str, Any]]) -> None:
    upstream_data = sum(1 for model in models if model.get("data_status") == "upstream")
    synthetic_data = sum(1 for model in models if model.get("data_status") == "synthetic")
    unavailable_data = sum(1 for model in models if model.get("data_status") == "unavailable")
    write_text(
        ROOT / "models_all" / "README.md",
        "\n".join(
            [
                "# Expanded Stan Example-Models Corpus",
                "",
                f"This directory contains `{len(models)}` Stan programs copied from `stan-dev/example-models`.",
                f"Matching upstream same-stem JSON data files were found for `{upstream_data}` programs.",
                f"Synthetic data were generated for `{synthetic_data}` programs.",
                f"Data generation failed for `{unavailable_data}` programs.",
                "",
                "Each directory contains `model.stan`, `metadata.json`, `source.md`, and `run.py`.",
                "All generated directories currently contain `data.json`.",
                "",
            ]
        ),
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--examples-root", default=os.environ.get("STAN_EXAMPLE_MODELS", "/tmp/stan-example-models"))
    parser.add_argument("--stanc", help="Path to SafeStan stanc.exe for synthetic data generation.")
    parser.add_argument("--force", action="store_true", help="Replace existing models_all/stan_example_models.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    examples_root = Path(args.examples_root).expanduser().resolve()
    if not examples_root.exists():
        raise SystemExit(f"example-models clone not found: {examples_root}")
    stanc = find_stanc(args.stanc)
    target_root = ROOT / "models_all" / "stan_example_models"
    if target_root.exists():
        if not args.force:
            raise SystemExit("models_all/stan_example_models already exists; pass --force to replace it.")
        shutil.rmtree(target_root)

    commit = git_revision(examples_root)
    stan_files = sorted(
        path
        for path in examples_root.rglob("*.stan")
        if ".git" not in path.relative_to(examples_root).parts
    )
    models = [materialize_model(examples_root, commit, path, stanc) for path in stan_files]
    write_json(
        ROOT / "expanded_model_manifest.json",
        {
            "stan_example_models_commit": commit,
            "default_run": DEFAULT_RUN,
            "models": models,
        },
    )
    write_expanded_readme(models)
    print(f"Wrote {len(models)} expanded Stan example models.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
