#!/usr/bin/env python3
"""Generate and validate SafeStan minor-transplant candidates.

This script corrects an important distinction in the compatibility reports:
`MINOR` is only a proven same-result SafeStan case once an explicit
`model_safe.stan` exists and an original-vs-safe run comparison has passed.

The generator intentionally uses conservative source-to-source rewrites:
  - move existing top-level parameter priors before parameter use,
  - vectorize simple one-line protected-data likelihood loops,
  - duplicate protected data used in transformed data as top-level data copies,
  - add explicit uniform(0, 1) priors for otherwise-unpriored [0, 1] parameters.

Candidates that cannot be rewritten conservatively remain ungenerated and are
reported as such.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import tempfile
from collections import Counter
from dataclasses import asdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CMDSAFESTAN = Path("/tmp/cmdsafestan")
DEFAULT_STANC = DEFAULT_CMDSAFESTAN / "safestan" / "_build" / "default" / "src" / "stanc" / "stanc.exe"

STATUS_GENERATED = "generated"
STATUS_NOT_GENERATED = "not-generated"
STATUS_COMPILE_FAILED = "compile-failed"
STATUS_ORIGINAL_RUN_FAILED = "original-run-failed"
STATUS_SAFE_RUN_FAILED = "safe-run-failed"
STATUS_COMPARE_PASSED = "same-lp"
STATUS_COMPARE_FAILED = "different-lp"
STATUS_SKIPPED_RUN = "run-skipped"

SAFE_MODEL = "model_safe.stan"
SAFE_DATA = "data_safe.json"

SAMPLE_RE = re.compile(r"^\s*([A-Za-z_]\w*)(?:\s*\[[^\n;]+\])?\s*~\s*([^;]+);\s*$", re.S)
PLAIN_SAMPLE_RE = re.compile(r"^\s*([A-Za-z_]\w*)\s*~\s*([^;]+);\s*$", re.S)
LOOP_SAMPLE_RE = re.compile(
    r"(?P<indent>^[ \t]*)for\s*\(\s*(?P<idx>[A-Za-z_]\w*)\s+in\s+1\s*:?\s*(?P<upper>[^\)]+?)\s*\)\s*\{\s*\n"
    r"(?P<body_indent>[ \t]*)(?P<lhs>[A-Za-z_]\w*)\s*\[\s*(?P=idx)\s*\]\s*~\s*(?P<rhs>[^;{}]+);\s*\n"
    r"(?P=indent)\}",
    re.M,
)


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2, sort_keys=True)
        handle.write("\n")


def run_command(command: list[str], *, cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, cwd=cwd, text=True, capture_output=True, check=False)


def strip_comments(source: str) -> str:
    source = re.sub(r"/\*.*?\*/", "", source, flags=re.S)
    return re.sub(r"//.*", "", source)


def find_block(source: str, block_name: str) -> tuple[int, int, int, int] | None:
    """Return (keyword_start, open_brace, body_start, close_brace) for block."""
    pattern = re.compile(r"\b" + re.escape(block_name).replace(r"\ ", r"\s+") + r"\s*\{")
    match = pattern.search(source)
    if not match:
        return None
    open_brace = source.find("{", match.start())
    depth = 0
    i = open_brace
    in_line_comment = False
    in_block_comment = False
    while i < len(source):
        ch = source[i]
        nxt = source[i + 1] if i + 1 < len(source) else ""
        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
            i += 1
            continue
        if in_block_comment:
            if ch == "*" and nxt == "/":
                in_block_comment = False
                i += 2
            else:
                i += 1
            continue
        if ch == "/" and nxt == "/":
            in_line_comment = True
            i += 2
            continue
        if ch == "/" and nxt == "*":
            in_block_comment = True
            i += 2
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return match.start(), open_brace, open_brace + 1, i
        i += 1
    return None


def split_top_level_statements(body: str) -> list[str]:
    statements: list[str] = []
    start = 0
    depth = 0
    i = 0
    in_line_comment = False
    in_block_comment = False
    while i < len(body):
        ch = body[i]
        nxt = body[i + 1] if i + 1 < len(body) else ""
        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
            i += 1
            continue
        if in_block_comment:
            if ch == "*" and nxt == "/":
                in_block_comment = False
                i += 2
            else:
                i += 1
            continue
        if ch == "/" and nxt == "/":
            in_line_comment = True
            i += 2
            continue
        if ch == "/" and nxt == "*":
            in_block_comment = True
            i += 2
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                end = i + 1
                statements.append(body[start:end])
                start = end
        elif ch == ";" and depth == 0:
            end = i + 1
            statements.append(body[start:end])
            start = end
        i += 1
    if start < len(body):
        statements.append(body[start:])
    return statements


def leading_indent(body: str) -> str:
    for line in body.splitlines():
        if line.strip():
            match = re.match(r"\s*", line)
            return match.group(0) if match else "  "
    return "  "


def is_declaration_statement(statement: str) -> bool:
    clean = strip_comments(statement).strip()
    if not clean or not clean.endswith(";"):
        return False
    if "~" in clean:
        return False
    return bool(
        re.match(
            r"^(array\s*\[|int\b|real\b|vector\b|row_vector\b|matrix\b|simplex\b|ordered\b|positive_ordered\b|cholesky_factor_corr\b|cholesky_factor_cov\b|corr_matrix\b|cov_matrix\b|unit_vector\b)",
            clean,
        )
    )


def plain_lhs_base(statement: str) -> str | None:
    clean = strip_comments(statement).strip()
    match = PLAIN_SAMPLE_RE.match(clean)
    if not match:
        return None
    return match.group(1)


def move_parameter_priors(source: str, parameter_names: set[str]) -> tuple[str, bool, str]:
    block = find_block(source, "model")
    if block is None:
        return source, False, "no model block"
    _, _, body_start, close_brace = block
    body = source[body_start:close_brace]
    statements = split_top_level_statements(body)
    movable: list[str] = []
    remaining: list[str] = []
    for statement in statements:
        base = plain_lhs_base(statement)
        if base in parameter_names:
            movable.append(statement)
        else:
            remaining.append(statement)
    if not movable:
        return source, False, "no top-level plain parameter priors to move"

    already_prefix = True
    seen_non_decl_or_prior = False
    for statement in statements:
        base = plain_lhs_base(statement)
        if base in parameter_names and not seen_non_decl_or_prior:
            continue
        if is_declaration_statement(statement) or not strip_comments(statement).strip():
            continue
        if base in parameter_names:
            already_prefix = False
            break
        seen_non_decl_or_prior = True
    if already_prefix:
        return source, False, "parameter priors already precede other top-level statements"

    insert_at = 0
    while insert_at < len(remaining) and (
        is_declaration_statement(remaining[insert_at]) or not strip_comments(remaining[insert_at]).strip()
    ):
        insert_at += 1
    new_statements = remaining[:insert_at] + movable + remaining[insert_at:]
    return source[:body_start] + "".join(new_statements) + source[close_brace:], True, (
        f"moved {len(movable)} top-level parameter prior statement(s)"
    )


def vectorize_simple_likelihood_loops(source: str, protected_vars: set[str]) -> tuple[str, bool, str]:
    block = find_block(source, "model")
    if block is None:
        return source, False, "no model block"
    _, _, body_start, close_brace = block
    body = source[body_start:close_brace]
    replacements = 0

    def repl(match: re.Match[str]) -> str:
        nonlocal replacements
        lhs = match.group("lhs")
        if lhs not in protected_vars:
            return match.group(0)
        idx = match.group("idx")
        rhs = match.group("rhs")
        rhs_vec = re.sub(r"\[\s*" + re.escape(idx) + r"\s*\]", "", rhs)
        replacements += 1
        return f"{match.group('indent')}{lhs} ~ {rhs_vec};"

    new_body = LOOP_SAMPLE_RE.sub(repl, body)
    if replacements == 0:
        return source, False, "no simple protected-data likelihood loops vectorized"
    return source[:body_start] + new_body + source[close_brace:], True, (
        f"vectorized {replacements} protected-data likelihood loop(s)"
    )


def declared_names_in_sampling(source: str) -> set[str]:
    names: set[str] = set()
    for match in re.finditer(r"([^;{}]+?)~\s*[A-Za-z_]\w*\s*\(", strip_comments(source), flags=re.M):
        lhs = match.group(1).split("\n")[-1].split(";")[-1].strip()
        base = re.match(r"([A-Za-z_]\w*)", lhs)
        if base:
            names.add(base.group(1))
    return names


def parameter_names_from_stanc_info(stanc: Path, stan_file: Path) -> set[str]:
    result = run_command([str(stanc), "--info", str(stan_file)])
    if result.returncode != 0:
        return set()
    try:
        info = json.loads(result.stdout)
    except json.JSONDecodeError:
        return set()
    return set(info.get("parameters", {}))


def data_declaration_for_var(source: str, var: str) -> str | None:
    block = find_block(source, "data")
    if block is None:
        return None
    _, _, body_start, close_brace = block
    body = source[body_start:close_brace]
    for statement in split_top_level_statements(body):
        clean = strip_comments(statement)
        if re.search(r"\b" + re.escape(var) + r"\s*;", clean):
            declaration = clean.strip()
            return declaration
    return None


def rename_declared_var(statement: str, old: str, new: str) -> str:
    return re.sub(r"\b" + re.escape(old) + r"\b(?=\s*;)", new, statement, count=1)


def duplicate_protected_for_transformed_data(source: str, protected_vars: list[str]) -> tuple[str, dict[str, str], bool, str]:
    td_block = find_block(source, "transformed data")
    data_block = find_block(source, "data")
    if td_block is None or data_block is None:
        return source, {}, False, "no transformed data block"
    _, _, td_body_start, td_close = td_block
    td_body = source[td_body_start:td_close]
    clean_td = strip_comments(td_body)
    copy_map: dict[str, str] = {}
    declarations: list[str] = []
    for var in protected_vars:
        if not re.search(r"\b" + re.escape(var) + r"\b", clean_td):
            continue
        decl = data_declaration_for_var(source, var)
        if decl is None:
            continue
        copy_name = f"{var}_safestan_copy"
        copy_map[var] = copy_name
        declarations.append(rename_declared_var(decl, var, copy_name))
    if not copy_map:
        return source, {}, False, "no protected data references in transformed data could be duplicated"

    _, _, _, data_close = data_block
    data_body = source[data_block[2] : data_close]
    indent = leading_indent(data_body)
    decl_text = ""
    if not data_body.endswith("\n"):
        decl_text += "\n"
    decl_text += f"{indent}// SafeStan duplicate(s) for transformed-data summaries.\n"
    for decl in declarations:
        decl_text += indent + decl.strip() + "\n"
    source = source[:data_close] + decl_text + source[data_close:]

    td_block = find_block(source, "transformed data")
    assert td_block is not None
    _, _, td_body_start, td_close = td_block
    td_body = source[td_body_start:td_close]
    for old, new in copy_map.items():
        td_body = re.sub(r"\b" + re.escape(old) + r"\b", new, td_body)
    source = source[:td_body_start] + td_body + source[td_close:]
    return source, copy_map, True, f"duplicated {len(copy_map)} protected data variable(s) for transformed data"


def bounded_unit_parameters(source: str) -> set[str]:
    block = find_block(source, "parameters")
    if block is None:
        return set()
    _, _, body_start, close_brace = block
    body = source[body_start:close_brace]
    names: set[str] = set()
    for statement in split_top_level_statements(body):
        clean = strip_comments(statement)
        if not re.search(r"<\s*lower\s*=\s*0\s*,\s*upper\s*=\s*1\s*>", clean):
            continue
        name_match = re.search(r"\b([A-Za-z_]\w*)\s*;\s*$", clean.strip())
        if name_match:
            names.add(name_match.group(1))
    return names


def add_unit_uniform_priors(source: str, parameter_names: set[str]) -> tuple[str, bool, str]:
    sampled = declared_names_in_sampling(source)
    missing = sorted((bounded_unit_parameters(source) & parameter_names) - sampled)
    if not missing:
        return source, False, "no missing bounded [0,1] parameter priors"
    block = find_block(source, "model")
    if block is None:
        return source, False, "no model block"
    _, _, body_start, close_brace = block
    body = source[body_start:close_brace]
    statements = split_top_level_statements(body)
    insert_at = 0
    while insert_at < len(statements) and (
        is_declaration_statement(statements[insert_at]) or not strip_comments(statements[insert_at]).strip()
    ):
        insert_at += 1
    indent = leading_indent(body)
    prefix = "\n" if insert_at == 0 and body.startswith("\n") else ""
    prior_text = prefix + "".join(f"{indent}{name} ~ uniform(0, 1);\n" for name in missing)
    statements.insert(insert_at, prior_text)
    return source[:body_start] + "".join(statements) + source[close_brace:], True, (
        f"added explicit uniform(0, 1) prior(s) for {', '.join(missing)}"
    )


def transform_rat_growth(source: str, data: dict[str, Any]) -> tuple[str, dict[str, Any], list[str], bool, str]:
    if "matrix[N, T] y;" not in source:
        return source, data, ["y"], False, "rat-growth flattening pattern not found"
    safe_data = json.loads(json.dumps(data))
    y = safe_data.get("y")
    if not isinstance(y, list):
        return source, data, ["y"], False, "rat-growth data did not contain matrix y"
    safe_data["y_flat"] = [value for row in y for value in row]
    safe_source = source.replace(
        "  matrix[N, T] y;\n",
        "  matrix[N, T] y;\n  vector[N * T] y_flat;\n",
    )
    safe_source = safe_source.replace(
        "  vector[N] beta = mu_beta + sigma_beta * beta_raw;\n",
        (
            "  vector[N] beta = mu_beta + sigma_beta * beta_raw;\n"
            "  vector[N * T] y_hat;\n"
            "  for (n in 1 : N) {\n"
            "    for (t in 1 : T) {\n"
            "      y_hat[(n - 1) * T + t] = alpha[n] + beta[n] * time[t];\n"
            "    }\n"
            "  }\n"
        ),
    )
    safe_source = safe_source.replace(
        (
            "  for (n in 1 : N) {\n"
            "    for (t in 1 : T) {\n"
            "      y[n, t] ~ normal(alpha[n] + beta[n] * time[t], sigma_y);\n"
            "    }\n"
            "  }\n"
        ),
        "  y_flat ~ normal(y_hat, sigma_y);\n",
    )
    return safe_source, safe_data, ["y_flat"], True, "flattened matrix y into protected vector y_flat"


def transform_geometric_failures(source: str, data: dict[str, Any]) -> tuple[str, dict[str, Any], list[str], bool, str]:
    if "y_failures" not in source:
        return source, data, ["y"], False, "geometric shifted-count pattern not found"
    safe_data = json.loads(json.dumps(data))
    y = safe_data.get("y")
    if not isinstance(y, list):
        return source, data, ["y"], False, "geometric data did not contain vector y"
    safe_data["y_failures"] = [int(value) - 1 for value in y]
    safe_source = source.replace(
        "  array[N] int<lower=1> y;\n",
        "  array[N] int<lower=1> y;\n  array[N] int<lower=0> y_failures;\n",
    )
    safe_source = re.sub(r"\ntransformed data\s*\{.*?\n\}\n", "\n", safe_source, flags=re.S, count=1)
    return safe_source, safe_data, ["y_failures"], True, "promoted zero-based failure counts to protected data y_failures"


def compile_safestan(stanc: Path, stan_file: Path, protect_vars: list[str]) -> dict[str, Any]:
    if not protect_vars:
        return {"status": "skipped", "returncode": None, "output": "No protected vars"}
    with tempfile.TemporaryDirectory(prefix="minor-safe-compile-") as tmp_dir:
        output = Path(tmp_dir) / "model.hpp"
        result = run_command(
            [str(stanc), "--sstanc", f"--sstan-protect={','.join(protect_vars)}", "-o", str(output), str(stan_file)]
        )
    combined = (result.stdout + result.stderr).strip()
    return {"status": "pass" if result.returncode == 0 else "fail", "returncode": result.returncode, "output": combined}


def extract_violation(output: str) -> str | None:
    marker = "SStan violation:"
    idx = output.find(marker)
    if idx < 0:
        return None
    return output[idx:].splitlines()[0].strip()


def generate_candidate(
    *,
    model_id: str,
    source: str,
    data: dict[str, Any],
    parameter_names: set[str],
    protected_vars: list[str],
    reason: str,
) -> tuple[str | None, dict[str, Any] | None, list[str], list[str]]:
    safe_source = source
    safe_data = json.loads(json.dumps(data))
    notes: list[str] = []
    safe_protect_vars = list(protected_vars)
    reason_lower = reason.lower()

    if model_id == "rat-growth":
        safe_source, safe_data, safe_protect_vars, changed, note = transform_rat_growth(safe_source, safe_data)
        notes.append(note)
        if changed:
            return safe_source, safe_data, safe_protect_vars, notes

    if model_id == "geometric-distribution":
        safe_source, safe_data, safe_protect_vars, changed, note = transform_geometric_failures(safe_source, safe_data)
        notes.append(note)
        if changed:
            return safe_source, safe_data, safe_protect_vars, notes

    if "protected-data summaries" in reason_lower or "derived protected-data" in reason_lower or "transformed data" in reason_lower:
        safe_source, copy_map, _changed, note = duplicate_protected_for_transformed_data(safe_source, safe_protect_vars)
        notes.append(note)
        for old, new in copy_map.items():
            if old in safe_data:
                safe_data[new] = safe_data[old]

    if "parameter priors" in reason_lower or "parameter used before" in reason_lower:
        safe_source, _changed, note = move_parameter_priors(safe_source, parameter_names)
        notes.append(note)

    if "vectoriz" in reason_lower or "indexed/projection" in reason_lower or "inside loop" in reason_lower:
        safe_source, _changed, note = vectorize_simple_likelihood_loops(safe_source, set(safe_protect_vars))
        notes.append(note)

    safe_source, _changed, note = add_unit_uniform_priors(safe_source, parameter_names)
    notes.append(note)

    if safe_source == source:
        return None, None, safe_protect_vars, notes
    return safe_source, safe_data, safe_protect_vars, notes


def import_cmdsafestan_api(cmdsafestan_root: Path):
    sys.path.insert(0, str(cmdsafestan_root))
    from cmdsafestan.api import evaluate_model_string, init  # type: ignore

    return evaluate_model_string, init


def run_pair_with_cmdsafestan(
    *,
    cmdsafestan_root: Path,
    runtime: Any,
    original_source: str,
    safe_source: str,
    original_data: dict[str, Any],
    safe_data: dict[str, Any],
    protect_vars: list[str],
    jobs: int,
    seed: int,
) -> dict[str, Any]:
    evaluate_model_string, _ = import_cmdsafestan_api(cmdsafestan_root)
    started = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    original = evaluate_model_string(
        original_source,
        original_data,
        protect=protect_vars or ["y"],
        runtime=runtime,
        jobs=jobs,
        seed=seed,
        enforce_safety=False,
        stream_output=False,
    )
    if original.run_returncode != 0 or original.log_likelihood is None:
        return {
            "validation_status": STATUS_ORIGINAL_RUN_FAILED,
            "started_at": started,
            "original": asdict(original),
            "safe": None,
            "abs_lp_diff": None,
            "rel_lp_diff": None,
        }
    safe = evaluate_model_string(
        safe_source,
        safe_data,
        protect=protect_vars,
        runtime=runtime,
        jobs=jobs,
        seed=seed,
        enforce_safety=True,
        stream_output=False,
    )
    if safe.run_returncode != 0 or safe.log_likelihood is None:
        return {
            "validation_status": STATUS_SAFE_RUN_FAILED,
            "started_at": started,
            "original": asdict(original),
            "safe": asdict(safe),
            "abs_lp_diff": None,
            "rel_lp_diff": None,
        }
    abs_diff = abs(original.log_likelihood - safe.log_likelihood)
    denom = max(1.0, abs(original.log_likelihood), abs(safe.log_likelihood))
    rel_diff = abs_diff / denom
    return {
        "validation_status": STATUS_COMPARE_PASSED if abs_diff <= 1e-8 or rel_diff <= 1e-10 else STATUS_COMPARE_FAILED,
        "started_at": started,
        "original": asdict(original),
        "safe": asdict(safe),
        "abs_lp_diff": abs_diff,
        "rel_lp_diff": rel_diff,
    }


def init_runtime(cmdsafestan_root: Path, jobs: int):
    _, init = import_cmdsafestan_api(cmdsafestan_root)
    return init(
        cmdstan_root=cmdsafestan_root,
        stanc3="safestan",
        runtime_root="safestan/stan",
        tmp_root=".cmdsafestan-tmp",
        bootstrap=True,
        build_runtime=True,
        jobs=jobs,
        stream_output=True,
    )


def model_link(path: str, title: str) -> str:
    return f"[{title}]({path}/)"


def escape_md(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ")


def write_validation_md(path: Path, rows: list[dict[str, Any]], metadata: dict[str, Any]) -> None:
    counts = Counter(row["validation_status"] for row in rows)
    generated = sum(1 for row in rows if row.get("model_safe_exists"))
    lines = [
        "# SafeStan Minor Validation",
        "",
        f"Generated: {metadata['generated_at']}",
        "",
        "This report validates models previously classified as `MINOR` candidates by creating explicit `model_safe.stan` files where a conservative same-density rewrite is available and, when enabled, running original plain mode vs safe mode through `cmdsafestan`.",
        "",
        "## Summary",
        "",
        f"- Candidate MINOR models: `{len(rows)}`",
        f"- `model_safe.stan` generated/present: `{generated}`",
    ]
    for status, count in sorted(counts.items()):
        lines.append(f"- `{status}`: `{count}`")
    lines.extend(
        [
            "",
            "## Results",
            "",
            "| Model | Data | Protect | Safe file | Validation | lp__ diff | Transform notes |",
            "|---|---|---|---|---|---:|---|",
        ]
    )
    for row in rows:
        protect = ", ".join(row.get("safe_protect_vars") or row.get("protect_vars") or []) or "-"
        diff = row.get("abs_lp_diff")
        diff_text = "-" if diff is None else f"{diff:.3g}"
        notes = "; ".join(row.get("transform_notes") or []) or row.get("message") or "-"
        safe_file = "yes" if row.get("model_safe_exists") else "no"
        lines.append(
            "| "
            + " | ".join(
                [
                    model_link(row["path"], escape_md(row["title"])),
                    f"`{escape_md(row.get('data_status') or '-')}`",
                    f"`{escape_md(protect)}`",
                    f"`{safe_file}`",
                    f"`{row['validation_status']}`",
                    f"`{diff_text}`",
                    escape_md(notes),
                ]
            )
            + " |"
        )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def validation_label(row: dict[str, Any] | None) -> str:
    if row is None:
        return "-"
    status = row.get("validation_status", "-")
    if status == STATUS_COMPARE_PASSED:
        return "`same-lp`"
    if status == STATUS_SKIPPED_RUN and row.get("model_safe_exists"):
        return "`safe-compiled; run skipped`"
    return f"`{status}`"


def patch_results_table(results_path: Path, validation_by_id: dict[str, dict[str, Any]]) -> None:
    if not results_path.exists():
        return
    text = results_path.read_text(encoding="utf-8")
    text = text.replace(
        "The `MINOR` class is not a completed equivalence run; it marks models where the required transplant is expected to preserve the posterior when reshaped/duplicated data are consistent.",
        "The `MINOR` class is a candidate label unless the Validation column shows a passing original-vs-safe run comparison.",
    )
    header = "| Source | Model | Data | Protected data | Status | Compiler result | Reason / transplant note |"
    new_header = "| Source | Model | Data | Protected data | Status | Compiler result | Validation | Reason / transplant note |"
    sep = "|---|---|---|---|---|---|---|"
    new_sep = "|---|---|---|---|---|---|---|---|"
    if new_header not in text and header in text:
        text = text.replace(header, new_header)
        text = text.replace(sep, new_sep, 1)
    lines = text.splitlines()
    out: list[str] = []
    in_results = False
    for line in lines:
        if line == new_header:
            in_results = True
            out.append(line)
            continue
        if in_results and line.startswith("## "):
            in_results = False
        if in_results and line.startswith("|") and line not in (new_header, new_sep):
            parts = [part.strip() for part in line.strip().strip("|").split("|")]
            if len(parts) in (7, 8):
                model_cell = parts[1]
                match = re.search(r"\]\(([^)]+)/\)", model_cell)
                row = None
                if match:
                    model_path = match.group(1)
                    row = next((v for v in validation_by_id.values() if v.get("path") == model_path), None)
                if len(parts) == 7:
                    parts.insert(6, validation_label(row))
                else:
                    parts[6] = validation_label(row)
                line = "| " + " | ".join(parts) + " |"
        out.append(line)
    results_path.write_text("\n".join(out) + "\n", encoding="utf-8")


def patch_model_list_table(model_list_path: Path, validation_by_id: dict[str, dict[str, Any]]) -> None:
    if not model_list_path.exists():
        return
    text = model_list_path.read_text(encoding="utf-8")
    header = "| Source | Difficulty | Model | Description | Upstream source | SafeStan status |"
    new_header = "| Source | Difficulty | Model | Description | Upstream source | SafeStan status | Validation |"
    sep = "|---|---|---|---|---|---|"
    new_sep = "|---|---|---|---|---|---|---|"
    if new_header not in text and header in text:
        text = text.replace(header, new_header)
        text = text.replace(sep, new_sep, 1)
    lines = text.splitlines()
    out: list[str] = []
    in_table = False
    for line in lines:
        if line == new_header:
            in_table = True
            out.append(line)
            continue
        if in_table and line.startswith("## "):
            in_table = False
        if in_table and line.startswith("|") and line not in (new_header, new_sep):
            parts = [part.strip() for part in line.strip().strip("|").split("|")]
            if len(parts) in (6, 7):
                model_cell = parts[2]
                match = re.search(r"\]\(([^)]+)/\)", model_cell)
                row = None
                if match:
                    model_path = match.group(1)
                    row = next((v for v in validation_by_id.values() if v.get("path") == model_path), None)
                if len(parts) == 6:
                    parts.append(validation_label(row))
                else:
                    parts[6] = validation_label(row)
                line = "| " + " | ".join(parts) + " |"
        out.append(line)
    model_list_path.write_text("\n".join(out) + "\n", encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", default=str(ROOT / "expanded_model_manifest.json"))
    parser.add_argument("--compatibility", default=str(ROOT / "safestan_compatibility_all.json"))
    parser.add_argument("--json-output", default=str(ROOT / "minor_validation_all.json"))
    parser.add_argument("--md-output", default=str(ROOT / "MINOR_VALIDATION_ALL.md"))
    parser.add_argument("--results-md", default=str(ROOT / "ALL_RESULTS.md"))
    parser.add_argument("--model-list-md", default=str(ROOT / "ALL_MODEL_LIST.md"))
    parser.add_argument("--stanc", default=str(DEFAULT_STANC))
    parser.add_argument("--cmdsafestan-root", default=str(DEFAULT_CMDSAFESTAN))
    parser.add_argument("--jobs", type=int, default=2)
    parser.add_argument("--seed", type=int, default=12345)
    parser.add_argument("--run", action="store_true", help="Run original and safe models after SafeStan compile succeeds.")
    parser.add_argument("--skip-runtime-init", action="store_true", help="Do not bootstrap CmdStan runtime; compile/generate only.")
    parser.add_argument("--limit", type=int, help="Limit number of MINOR candidates processed.")
    parser.add_argument("--only", action="append", default=[], help="Only process model id(s); repeatable.")
    parser.add_argument("--write-report-markers", action="store_true", help="Add Validation columns to markdown reports.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    manifest = load_json(Path(args.manifest))
    compat = load_json(Path(args.compatibility))
    stanc = Path(args.stanc).expanduser().resolve()
    cmdsafestan_root = Path(args.cmdsafestan_root).expanduser().resolve()
    if not stanc.exists():
        raise SystemExit(f"SafeStan stanc not found: {stanc}")

    by_id = {model["id"]: model for model in manifest["models"]}
    candidates = [row for row in compat["results"] if row.get("classification") == "MINOR"]
    if args.only:
        only = set(args.only)
        candidates = [row for row in candidates if row["id"] in only]
    if args.limit is not None:
        candidates = candidates[: args.limit]

    runtime = None
    if args.run and not args.skip_runtime_init:
        runtime = init_runtime(cmdsafestan_root, args.jobs)

    rows: list[dict[str, Any]] = []
    for idx, compat_row in enumerate(candidates, start=1):
        model = by_id[compat_row["id"]]
        model_dir = ROOT / model["path"]
        stan_file = model_dir / model.get("stan_file", "model.stan")
        data_file = model_dir / model.get("data_file", "data.json")
        source = stan_file.read_text(encoding="utf-8")
        data = load_json(data_file)
        parameter_names = parameter_names_from_stanc_info(stanc, stan_file)
        protect_vars = list(compat_row.get("protect_vars") or [])
        print(f"[{idx}/{len(candidates)}] {compat_row['id']}", flush=True)
        safe_source, safe_data, safe_protect, notes = generate_candidate(
            model_id=compat_row["id"],
            source=source,
            data=data,
            parameter_names=parameter_names,
            protected_vars=protect_vars,
            reason=compat_row.get("reason", ""),
        )
        row: dict[str, Any] = {
            "id": compat_row["id"],
            "title": model["title"],
            "path": model["path"],
            "data_status": model.get("data_status") or compat_row.get("data_status"),
            "protect_vars": protect_vars,
            "safe_protect_vars": safe_protect,
            "reason": compat_row.get("reason"),
            "transform_notes": notes,
            "model_safe_exists": False,
            "data_safe_exists": False,
            "safe_compile": None,
            "validation_status": STATUS_NOT_GENERATED,
            "abs_lp_diff": None,
            "rel_lp_diff": None,
        }
        if safe_source is None or safe_data is None:
            row["message"] = "No conservative source transform generated."
            rows.append(row)
            continue

        with tempfile.TemporaryDirectory(prefix="minor-candidate-") as tmp_dir:
            tmp_stan = Path(tmp_dir) / SAFE_MODEL
            tmp_stan.write_text(safe_source, encoding="utf-8")
            compile_result = compile_safestan(stanc, tmp_stan, safe_protect)
        row["safe_compile"] = compile_result
        if compile_result["status"] != "pass":
            row["validation_status"] = STATUS_COMPILE_FAILED
            row["message"] = extract_violation(compile_result.get("output", "")) or "SafeStan compile failed."
            rows.append(row)
            continue

        (model_dir / SAFE_MODEL).write_text(safe_source, encoding="utf-8")
        write_json(model_dir / SAFE_DATA, safe_data)
        row["model_safe_exists"] = True
        row["data_safe_exists"] = True
        row["validation_status"] = STATUS_GENERATED

        if not args.run:
            row["validation_status"] = STATUS_SKIPPED_RUN
            rows.append(row)
            continue
        if runtime is None:
            row["validation_status"] = STATUS_SKIPPED_RUN
            row["message"] = "Runtime initialization was skipped."
            rows.append(row)
            continue
        row.update(
            run_pair_with_cmdsafestan(
                cmdsafestan_root=cmdsafestan_root,
                runtime=runtime,
                original_source=source,
                safe_source=safe_source,
                original_data=data,
                safe_data=safe_data,
                protect_vars=safe_protect,
                jobs=args.jobs,
                seed=args.seed,
            )
        )
        rows.append(row)

    metadata = {
        "generated_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
        "manifest": str(Path(args.manifest).resolve()),
        "compatibility": str(Path(args.compatibility).resolve()),
        "stanc": str(stanc),
        "cmdsafestan_root": str(cmdsafestan_root),
        "run_enabled": args.run,
    }
    payload = {"metadata": metadata, "results": rows}
    write_json(Path(args.json_output), payload)
    write_validation_md(Path(args.md_output), rows, metadata)
    if args.write_report_markers:
        validation_by_id = {row["id"]: row for row in rows}
        patch_results_table(Path(args.results_md), validation_by_id)
        patch_model_list_table(Path(args.model_list_md), validation_by_id)

    counts = Counter(row["validation_status"] for row in rows)
    print(" ".join(f"{key}={counts[key]}" for key in sorted(counts)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
