#!/usr/bin/env python3
"""Audit the corpus against SafeStan compile-time restrictions.

The checker uses the real SafeStan stanc frontend when available. It records:
  - which top-level data variables were inferred for --sstan-protect,
  - whether the original model compiles in SafeStan mode as-is,
  - the compatibility class used in RESULTS.md and MODEL_LIST.md.

The classification layer is intentionally explicit for this 45-model corpus:
the compiler tells us "as-is"; the remaining "minor" vs "major" distinction
depends on whether the necessary transplant preserves the original posterior
up to data reshaping/vectorization, or whether it needs a density-changing or
substantial model rewrite.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import tempfile
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]

STATUS_AS_IS = "AS-IS"
STATUS_MINOR = "MINOR"
STATUS_MAJOR = "MAJOR"

STATUS_LABELS = {
    STATUS_AS_IS: "compiles with SafeStan as written",
    STATUS_MINOR: "expected same-result SafeStan transplant",
    STATUS_MAJOR: "needs substantial or density-changing rewrite",
}


MINOR_MODELS: dict[str, str] = {
    "binary-trials-no-pool": (
        "Move protected-data summary statistics out of transformed data or pass "
        "them as separate data; add explicit uniform(0, 1) prior for bounded theta."
    ),
    "binary-trials-complete-pool": (
        "Move protected-data summary statistics out of transformed data or pass "
        "them as separate data; add explicit uniform(0, 1) prior for bounded theta."
    ),
    "binary-trials-hierarchical": (
        "Move protected-data summary statistics out of transformed data or pass "
        "them as separate data; model priors and likelihood are otherwise SafeStan-shaped."
    ),
    "binary-trials-hier-logit": (
        "Move protected-data summary statistics out of transformed data or pass "
        "them as separate data; model priors and likelihood are otherwise SafeStan-shaped."
    ),
    "soil-incubation-ode": (
        "Vectorize the indexed likelihood to a single `eCO2mean ~ normal(...)` statement."
    ),
    "rat-growth": (
        "Flatten the repeated-measures matrix into a protected vector and vectorize the likelihood."
    ),
    "geometric-distribution": (
        "Pass zero-based failure counts as a top-level protected data variable instead of deriving "
        "them from protected data in transformed data."
    ),
}


MAJOR_MODELS: dict[str, str] = {
    "normal-location": "Observed values live in transformed data and the unbounded mean has no proper prior.",
    "truncated-normal": "Uses indexed/truncated likelihood and unbounded parameters without proper priors.",
    "censored-normal": "Requires a censored-data target/lccdf contribution and lacks a proper prior for mu.",
    "multivariate-normal": "Distribution-signature stress test with repeated/partial observations, not a single protected likelihood.",
    "negative-binomial2": "Alpha has an implicit improper prior that SafeStan cannot express without changing the density.",
    "normal-mixture": "Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`.",
    "k-component-normal-mixture": "Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`.",
    "k-component-normal-mixture-simplex": "Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`.",
    "simple-regression": "Regression coefficients and scale have implicit improper priors.",
    "vector-regression": "Regression coefficients and scale have implicit improper priors.",
    "two-pl-regression-centered": "Gamma has an implicit improper prior and item/person priors need nontrivial restructuring.",
    "two-pl-regression-noncentered": "Gamma has an implicit improper prior and is used before any SafeStan prior statement.",
    "golf-putting-logistic": "Scale parameter has an implicit improper prior.",
    "worldcup-first-try": "Likelihood is derived from protected scores in transformed data and several parameters have implicit improper priors.",
    "worldcup-no-sqrt": "Likelihood is derived from protected scores in transformed data and several parameters have implicit improper priors.",
    "worldcup-fixed": "Likelihood is derived from protected scores in transformed data and several parameters have implicit improper priors.",
    "worldcup-replication": "Likelihood is derived from protected scores in transformed data and several parameters have implicit improper priors.",
    "worldcup-no-prior": "Intentionally omits priors, which SafeStan strict parameter discipline rejects.",
    "bym2-spatial-poisson": "Uses a user-defined ICAR distribution and an improper spatial prior.",
    "finite-mixture": "Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`.",
    "finite-gaussian-mixture": "Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`.",
    "dirichlet-multinomial-mixture": "Requires custom Dirichlet-multinomial mixture scoring via `target += log_sum_exp(...)`.",
    "markov-model": "Sequential likelihood is accumulated manually with protected observations in the recursion.",
    "hidden-markov-model": "Hidden-state forward algorithm requires manual `target += log_sum_exp(...)` scoring.",
    "medical-diagnosis": "Latent disease marginalization is implemented by manual `target += log_sum_exp(...)` scoring.",
    "burglary-bayesnet": "Latent Bayes-net states are marginalized by manual `target += log_sum_exp(...)` scoring.",
    "model-selection": "Discrete model indicator is marginalized by manual `target += log_sum_exp(...)` scoring.",
}


PROTECT_OVERRIDES: dict[str, list[str]] = {
    "geometric-distribution": ["y"],
}


SAMPLE_RE = re.compile(r"([^;{}]+?)~\s*([A-Za-z_]\w*)\s*\(", re.MULTILINE)


def strip_comments(source: str) -> str:
    source = re.sub(r"/\*.*?\*/", "", source, flags=re.DOTALL)
    return re.sub(r"//.*", "", source)


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2)
        handle.write("\n")


def run_command(command: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, capture_output=True, text=True)


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


def stanc_info(stanc: Path, stan_file: Path) -> tuple[dict[str, Any] | None, str | None]:
    result = run_command([str(stanc), "--info", str(stan_file)])
    if result.returncode != 0:
        return None, (result.stderr or result.stdout).strip()
    return json.loads(result.stdout), None


def sampling_statements(source: str) -> list[dict[str, str]]:
    clean = strip_comments(source)
    statements: list[dict[str, str]] = []
    for match in SAMPLE_RE.finditer(clean):
        lhs = match.group(1).split("\n")[-1].split(";")[-1].strip()
        base_match = re.match(r"([A-Za-z_]\w*)", lhs)
        statements.append(
            {
                "lhs": lhs,
                "lhs_base": base_match.group(1) if base_match else "",
                "distribution": match.group(2),
            }
        )
    return statements


def infer_protect_vars(model_id: str, info: dict[str, Any], statements: list[dict[str, str]]) -> list[str]:
    if model_id in PROTECT_OVERRIDES:
        return PROTECT_OVERRIDES[model_id]
    inputs = set(info.get("inputs", {}))
    protected: list[str] = []

    def add(name: str) -> None:
        if name in inputs and name not in protected:
            protected.append(name)

    for statement in statements:
        lhs = statement["lhs"]
        base = statement["lhs_base"]
        if base in inputs and "[" not in lhs and "." not in lhs:
            add(base)
    if protected:
        return protected

    # Fallback: use indexed data LHS variables so the compiler can expose the
    # exact SafeStan violation for models that only need vectorization.
    for statement in statements:
        add(statement["lhs_base"])
    return protected


def compile_safestan(stanc: Path, stan_file: Path, protect_vars: list[str]) -> dict[str, Any]:
    if not protect_vars:
        return {
            "status": "skipped",
            "returncode": None,
            "violation": "No top-level protected-data likelihood candidate was inferred.",
        }
    with tempfile.TemporaryDirectory(prefix="safestan-audit-") as tmp_dir:
        output = Path(tmp_dir) / "model.hpp"
        result = run_command(
            [
                str(stanc),
                "--sstanc",
                f"--sstan-protect={','.join(protect_vars)}",
                "-o",
                str(output),
                str(stan_file),
            ]
        )
    combined = (result.stderr or result.stdout).strip()
    return {
        "status": "pass" if result.returncode == 0 else "fail",
        "returncode": result.returncode,
        "violation": extract_violation(combined),
        "compiler_output": combined,
    }


def extract_violation(output: str) -> str:
    if not output:
        return ""
    marker = "SStan violation:"
    idx = output.find(marker)
    if idx >= 0:
        return output[idx:].splitlines()[0].strip()
    lines = [line.strip() for line in output.splitlines() if line.strip()]
    return lines[-1] if lines else output.strip()


def has_target_scoring(statements: list[dict[str, str]], source: str) -> bool:
    clean = strip_comments(source)
    return "target +=" in clean or "target(" in clean


def parameter_prior_lhs(statements: list[dict[str, str]], parameter_names: set[str]) -> set[str]:
    return {statement["lhs_base"] for statement in statements if statement["lhs_base"] in parameter_names}


def classify(
    model_id: str,
    safe_compile: dict[str, Any],
    *,
    source: str,
    statements: list[dict[str, str]],
    parameter_names: set[str],
) -> tuple[str, str]:
    if safe_compile["status"] == "pass":
        return STATUS_AS_IS, "Compiled with SafeStan using the inferred protected data variables."
    if model_id in MINOR_MODELS:
        return STATUS_MINOR, MINOR_MODELS[model_id]
    if model_id in MAJOR_MODELS:
        return STATUS_MAJOR, MAJOR_MODELS[model_id]
    violation = safe_compile.get("violation") or ""
    if has_target_scoring(statements, source):
        return STATUS_MAJOR, "Uses manual scoring (`target +=` or `target()`), which SafeStan forbids."
    if "user-defined distributions" in violation or "user-defined distribution" in violation:
        return STATUS_MAJOR, "Uses a user-defined probability distribution in a sampling statement."
    if "No top-level protected-data likelihood candidate" in violation:
        return STATUS_MAJOR, "No protected-data likelihood could be inferred automatically."
    if "parameter used before its unique prior statement" in violation:
        priored = parameter_prior_lhs(statements, parameter_names)
        if parameter_names and parameter_names.issubset(priored):
            return STATUS_MINOR, "Parameter priors exist but need to be moved before parameter use."
        return STATUS_MAJOR, "One or more parameters have implicit improper priors."
    if "left-hand side must be a plain identifier" in violation:
        return STATUS_MINOR, "Requires vectorizing or flattening an indexed/projection likelihood."
    if "protected data referenced in transformed data" in violation:
        return STATUS_MINOR, "Requires passing derived protected-data summaries separately or moving them after observation."
    if "protected data used before observation" in violation:
        return STATUS_MINOR, "Requires duplicated/reshaped protected history data so the likelihood observes protected data once."
    if "appears inside loop control flow" in violation:
        return STATUS_MINOR, "Requires vectorizing sampling statements out of loops."
    if "observed more than once" in violation:
        return STATUS_MAJOR, "Protected data are scored multiple times and need a substantive likelihood rewrite."
    return STATUS_MAJOR, "SafeStan rejected the original model and no same-result minor transplant is known."


def git_revision(path: Path) -> str | None:
    try:
        result = run_command(["git", "-C", str(path), "rev-parse", "HEAD"])
    except OSError:
        return None
    if result.returncode == 0:
        return result.stdout.strip()
    return None


def escape_cell(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ")


def markdown_model_link(model: dict[str, Any]) -> str:
    return f"[{escape_cell(model['title'])}]({model['path']}/)"


def source_link(model: dict[str, Any]) -> str:
    return f"[source]({model['source_url']})"


def data_status(model: dict[str, Any]) -> str:
    if model.get("data_status"):
        return str(model["data_status"])
    if model.get("data_file"):
        return "upstream"
    return "unavailable"


def write_model_list(
    manifest_models: list[dict[str, Any]],
    results_by_id: dict[str, dict[str, Any]],
    output_path: Path,
) -> None:
    lines = [
        "# Model List",
        "",
        "SafeStan status markers:",
        "",
        "- `AS-IS`: original `model.stan` compiles with SafeStan using the inferred `--sstan-protect` variables.",
        "- `MINOR`: expected same-result transplant, usually data reshaping, vectorization, or moving protected-data summaries.",
        "- `MAJOR`: requires substantial rewriting or a density-changing change such as replacing manual `target +=` scoring or adding improper-prior replacements.",
        "",
        "| Source | Difficulty | Model | Description | Upstream source | SafeStan status |",
        "|---|---|---|---|---|---|",
    ]
    for model in manifest_models:
        result = results_by_id[model["id"]]
        lines.append(
            "| "
            + " | ".join(
                [
                    escape_cell(model["source_group_label"]),
                    escape_cell(model["difficulty"]),
                    markdown_model_link(model),
                    escape_cell(model["description"]),
                    source_link(model),
                    f"`{result['classification']}`",
                ]
            )
            + " |"
        )
    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_results_md(
    manifest_models: list[dict[str, Any]],
    results: list[dict[str, Any]],
    stanc: Path | None,
    metadata: dict[str, Any],
    output_path: Path,
) -> None:
    by_id = {result["id"]: result for result in results}
    status_counts = Counter(result["classification"] for result in results)
    source_counts: dict[str, Counter[str]] = defaultdict(Counter)
    for model in manifest_models:
        source_counts[model["source_group_label"]][by_id[model["id"]]["classification"]] += 1

    lines = [
        "# SafeStan Compatibility Results",
        "",
        f"Generated: {metadata['generated_at']}",
        "",
        "This is a compiler-level SafeStan audit of the original `model.stan` files plus a manual same-result transplant assessment for rejected models.",
        "The `MINOR` class is not a completed equivalence run; it marks models where the required transplant is expected to preserve the posterior when reshaped/duplicated data are consistent.",
        "",
        "## Legend",
        "",
    ]
    for status, label in STATUS_LABELS.items():
        lines.append(f"- `{status}`: {label}.")
    lines.extend(
        [
            "",
            "## Compiler",
            "",
            f"- SafeStan stanc: `{stanc}`" if stanc else "- SafeStan stanc: not found",
            f"- cmdsafestan revision: `{metadata.get('cmdsafestan_revision') or 'unknown'}`",
            f"- safestan/stanc revision: `{metadata.get('safestan_revision') or 'unknown'}`",
            "",
            "## Summary",
            "",
            f"- Total models: `{len(results)}`",
            f"- `{STATUS_AS_IS}`: `{status_counts[STATUS_AS_IS]}`",
            f"- `{STATUS_MINOR}`: `{status_counts[STATUS_MINOR]}`",
            f"- `{STATUS_MAJOR}`: `{status_counts[STATUS_MAJOR]}`",
            "",
            "| Source | AS-IS | MINOR | MAJOR | Total |",
            "|---|---:|---:|---:|---:|",
        ]
    )
    for source, counts in source_counts.items():
        total = sum(counts.values())
        lines.append(
            f"| {escape_cell(source)} | {counts[STATUS_AS_IS]} | {counts[STATUS_MINOR]} | {counts[STATUS_MAJOR]} | {total} |"
        )
    lines.extend(
        [
            "",
            "## Model Results",
            "",
            "| Source | Model | Data | Protected data | Status | Compiler result | Reason / transplant note |",
            "|---|---|---|---|---|---|---|",
        ]
    )
    for model in manifest_models:
        result = by_id[model["id"]]
        protected = ", ".join(result["protect_vars"]) if result["protect_vars"] else "-"
        compile_status = result["safe_compile"]["status"]
        reason = result["reason"]
        if result["safe_compile"].get("violation") and result["classification"] != STATUS_AS_IS:
            reason = f"{reason} Compiler: {result['safe_compile']['violation']}"
        lines.append(
            "| "
            + " | ".join(
                [
                    escape_cell(model["source_group_label"]),
                    markdown_model_link(model),
                    f"`{escape_cell(result['data_status'])}`",
                    f"`{escape_cell(protected)}`",
                    f"`{result['classification']}`",
                    f"`{compile_status}`",
                    escape_cell(reason),
                ]
            )
            + " |"
        )
    lines.extend(
        [
            "",
            "## Notes",
            "",
            "- `AS-IS` was decided by running SafeStan `stanc` with `--sstanc` and inferred `--sstan-protect` variables.",
            "- `MINOR` generally means one of: move parameter priors before use, vectorize indexed likelihoods, flatten protected observations, or pass derived protected data as top-level data.",
            "- `MAJOR` generally means the model uses manual scoring (`target +=`), marginalized discrete latent structure, a user-defined probability distribution in `~`, or implicit improper priors that cannot be represented in SafeStan without changing the density.",
            "",
        ]
    )
    output_path.write_text("\n".join(lines), encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", default=str(ROOT / "model_manifest.json"))
    parser.add_argument("--stanc", help="Path to SafeStan stanc.exe.")
    parser.add_argument("--json-output", default=str(ROOT / "safestan_compatibility.json"))
    parser.add_argument("--results-output", default=str(ROOT / "RESULTS.md"))
    parser.add_argument("--model-list-output", default=str(ROOT / "MODEL_LIST.md"))
    parser.add_argument("--write", action="store_true", help="Write RESULTS.md and MODEL_LIST.md markers.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    manifest_path = Path(args.manifest).expanduser().resolve()
    manifest = load_json(manifest_path)
    stanc = find_stanc(args.stanc)
    if stanc is None:
        raise SystemExit("SafeStan stanc not found. Pass --stanc or set SAFESTAN_STANC.")

    results: list[dict[str, Any]] = []
    for model in manifest["models"]:
        model_dir = ROOT / model["path"]
        stan_file = model_dir / model.get("stan_file", "model.stan")
        source = stan_file.read_text(encoding="utf-8")
        info, info_error = stanc_info(stanc, stan_file)
        statements = sampling_statements(source)
        if info is None:
            protect_vars: list[str] = []
            parameter_names: set[str] = set()
            safe_compile = {"status": "plain-stan-fail", "returncode": 1, "violation": info_error}
        else:
            parameter_names = set(info.get("parameters", {}))
            protect_vars = infer_protect_vars(model["id"], info, statements)
            safe_compile = compile_safestan(stanc, stan_file, protect_vars)
        classification, reason = classify(
            model["id"],
            safe_compile,
            source=source,
            statements=statements,
            parameter_names=parameter_names,
        )
        results.append(
            {
                "id": model["id"],
                "title": model["title"],
                "path": model["path"],
                "source_group": model["source_group"],
                "source_group_label": model["source_group_label"],
                "difficulty": model["difficulty"],
                "data_status": data_status(model),
                "data_file": model.get("data_file"),
                "data_source": model.get("data_source"),
                "protect_vars": protect_vars,
                "classification": classification,
                "reason": reason,
                "safe_compile": safe_compile,
                "sampling_statements": statements,
            }
        )

    metadata = {
        "generated_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
        "stanc": str(stanc),
        "cmdsafestan_revision": git_revision(Path("/tmp/cmdsafestan")),
        "safestan_revision": git_revision(Path("/tmp/cmdsafestan/safestan")),
        "status_labels": STATUS_LABELS,
    }
    payload = {"metadata": metadata, "results": results}
    write_json(Path(args.json_output).expanduser().resolve(), payload)

    results_by_id = {result["id"]: result for result in results}
    if args.write:
        write_results_md(manifest["models"], results, stanc, metadata, Path(args.results_output).expanduser().resolve())
        write_model_list(manifest["models"], results_by_id, Path(args.model_list_output).expanduser().resolve())

    counts = Counter(result["classification"] for result in results)
    print(f"AS-IS={counts[STATUS_AS_IS]} MINOR={counts[STATUS_MINOR]} MAJOR={counts[STATUS_MAJOR]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
