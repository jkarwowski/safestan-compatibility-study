#!/usr/bin/env python3
"""Modernize legacy Stan syntax in the model corpus.

The imported corpora contain many pre-Stan-2.26 declarations such as
`real y[N];` and `real[] x` in function signatures.  Current stanc rejects
those programs before its canonicalizer can run, so this script performs the
small syntactic rewrite needed to make them parse:

    real y[N];              -> array[N] real y;
    vector[K] beta[J];      -> array[J] vector[K] beta;
    real[] x                -> array[] real x
    real[,] x               -> array[,] real x

It also normalizes `#` comments to `//` comments and rewrites the old `fabs`
function name to `abs`.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MODELS_ROOT = ROOT / "models"

TYPE_NAMES = {
    "int",
    "real",
    "vector",
    "row_vector",
    "matrix",
    "simplex",
    "ordered",
    "positive_ordered",
    "unit_vector",
    "cov_matrix",
    "corr_matrix",
    "cholesky_factor_cov",
    "cholesky_factor_corr",
}

# If one of these types appears with dimensions only after the variable name,
# the source is usually an old or otherwise invalid spelling of the type's own
# dimensions, e.g. `row_vector a[3]`.
SHAPED_TYPE_ARITY = {
    "vector": {1},
    "row_vector": {1},
    "simplex": {1},
    "ordered": {1},
    "positive_ordered": {1},
    "unit_vector": {1},
    "cov_matrix": {1},
    "corr_matrix": {1},
    "matrix": {2},
    "cholesky_factor_cov": {1, 2},
    "cholesky_factor_corr": {1, 2},
}


@dataclass
class FileStats:
    hash_comments: int = 0
    unsized_arrays: int = 0
    postfix_arrays: int = 0
    shaped_type_dims: int = 0
    fabs_calls: int = 0
    cov_exp_quad_calls: int = 0
    cholesky_decompose_gpu_calls: int = 0
    probability_call_bars: int = 0
    probability_signature_commas: int = 0
    missing_semicolons: int = 0

    def __iadd__(self, other: "FileStats") -> "FileStats":
        self.hash_comments += other.hash_comments
        self.unsized_arrays += other.unsized_arrays
        self.postfix_arrays += other.postfix_arrays
        self.shaped_type_dims += other.shaped_type_dims
        self.fabs_calls += other.fabs_calls
        self.cov_exp_quad_calls += other.cov_exp_quad_calls
        self.cholesky_decompose_gpu_calls += other.cholesky_decompose_gpu_calls
        self.probability_call_bars += other.probability_call_bars
        self.probability_signature_commas += other.probability_signature_commas
        self.missing_semicolons += other.missing_semicolons
        return self


def split_top_level_commas(value: str) -> list[str]:
    if value.strip() == "":
        return [""]
    parts: list[str] = []
    current: list[str] = []
    bracket_depth = 0
    paren_depth = 0
    angle_depth = 0
    for char in value:
        if char == "[":
            bracket_depth += 1
        elif char == "]" and bracket_depth:
            bracket_depth -= 1
        elif char == "(":
            paren_depth += 1
        elif char == ")" and paren_depth:
            paren_depth -= 1
        elif char == "<":
            angle_depth += 1
        elif char == ">" and angle_depth:
            angle_depth -= 1
        if char == "," and bracket_depth == paren_depth == angle_depth == 0:
            parts.append("".join(current).strip())
            current = []
        else:
            current.append(char)
    tail = "".join(current).strip()
    if tail or value.rstrip().endswith(","):
        parts.append(tail)
    return parts


def is_ident_start(char: str) -> bool:
    return char == "_" or char.isalpha()


def is_ident_char(char: str) -> bool:
    return char == "_" or char.isalnum()


def skip_ws(text: str, index: int) -> int:
    while index < len(text) and text[index].isspace():
        index += 1
    return index


def read_identifier(text: str, index: int) -> tuple[str | None, int]:
    if index >= len(text) or not is_ident_start(text[index]):
        return None, index
    end = index + 1
    while end < len(text) and is_ident_char(text[end]):
        end += 1
    return text[index:end], end


def read_balanced(text: str, index: int, opener: str, closer: str) -> tuple[str | None, int]:
    if index >= len(text) or text[index] != opener:
        return None, index
    depth = 1
    current: list[str] = []
    cursor = index + 1
    while cursor < len(text):
        char = text[cursor]
        if char == opener:
            depth += 1
        elif char == closer:
            depth -= 1
            if depth == 0:
                return "".join(current), cursor + 1
        current.append(char)
        cursor += 1
    return None, index


def read_constraint(text: str, index: int) -> tuple[str, int]:
    index = skip_ws(text, index)
    if index >= len(text) or text[index] != "<":
        return "", index
    content, end = read_balanced(text, index, "<", ">")
    if content is None:
        return "", index
    return f"<{content}>", end


def read_bracket(text: str, index: int) -> tuple[str | None, int]:
    index = skip_ws(text, index)
    return read_balanced(text, index, "[", "]")


def read_bracket_sequence(text: str, index: int) -> tuple[list[str], int]:
    dims: list[str] = []
    cursor = skip_ws(text, index)
    last_end = index
    while cursor < len(text) and text[cursor] == "[":
        content, end = read_bracket(text, cursor)
        if content is None:
            break
        dims.extend(split_top_level_commas(content))
        last_end = end
        cursor = skip_ws(text, end)
    return dims, last_end if dims else index


def is_empty_array_dims(dims: list[str]) -> bool:
    return bool(dims) and all(dim == "" or set(dim) <= {","} for dim in dims)


def array_dims_text(dims: list[str]) -> str:
    return ", ".join(dim.strip() for dim in dims)


def preceding_allows_type(text: str, index: int) -> bool:
    if index == 0:
        return True
    previous = text[index - 1]
    return not (is_ident_char(previous) or previous == "]")


def parse_type_prefix(text: str, index: int) -> tuple[str | None, str, int]:
    if not preceding_allows_type(text, index):
        return None, "", index
    name, cursor = read_identifier(text, index)
    if name not in TYPE_NAMES:
        return None, "", index
    constraint, cursor = read_constraint(text, cursor)
    return name, constraint, cursor


def convert_hash_comments(text: str, stats: FileStats) -> str:
    lines: list[str] = []
    for line in text.splitlines(keepends=True):
        stripped = line.lstrip()
        if stripped.startswith("#include") or stripped.startswith("# include"):
            lines.append(line)
            continue

        in_string = False
        escaped = False
        hash_index: int | None = None
        for index, char in enumerate(line):
            if line.startswith("//", index):
                break
            if escaped:
                escaped = False
                continue
            if char == "\\":
                escaped = True
                continue
            if char == '"':
                in_string = not in_string
            elif char == "#" and not in_string:
                hash_index = index
                break
        if hash_index is None:
            lines.append(line)
            continue
        stats.hash_comments += 1
        lines.append(f"{line[:hash_index]}//{line[hash_index + 1:]}")
    return "".join(lines)


def convert_unsized_array_types(code: str, stats: FileStats) -> str:
    output: list[str] = []
    cursor = 0
    while cursor < len(code):
        type_name, constraint, after_type = parse_type_prefix(code, cursor)
        if type_name is None:
            output.append(code[cursor])
            cursor += 1
            continue

        dims, after_dims = read_bracket_sequence(code, after_type)
        if not is_empty_array_dims(dims):
            output.append(code[cursor])
            cursor += 1
            continue

        after_dims_ws = skip_ws(code, after_dims)
        ident, _ = read_identifier(code, after_dims_ws)
        if ident is None:
            output.append(code[cursor])
            cursor += 1
            continue

        raw = code[cursor:after_dims]
        dim_text = "".join("," for _ in range(max(0, len(dims) - 1)))
        # Preserve `[,]` when it appears in a single bracket expression.
        if len(dims) == 1 and "," in raw:
            dim_text = raw[raw.find("[") + 1 : raw.rfind("]")].replace(" ", "")
        output.append(f"array[{dim_text}] {type_name}{constraint} ")
        cursor = skip_ws(code, after_dims)
        stats.unsized_arrays += 1
    return "".join(output)


def replacement_for_postfix(
    type_name: str,
    constraint: str,
    base_dims: list[str],
    var_name: str,
    array_dims: list[str],
    stats: FileStats,
) -> str:
    if not base_dims and type_name in SHAPED_TYPE_ARITY and len(array_dims) in SHAPED_TYPE_ARITY[type_name]:
        stats.shaped_type_dims += 1
        return f"{type_name}{constraint}[{array_dims_text(array_dims)}] {var_name}"

    stats.postfix_arrays += 1
    base_dim_text = f"[{array_dims_text(base_dims)}]" if base_dims else ""
    return f"array[{array_dims_text(array_dims)}] {type_name}{constraint}{base_dim_text} {var_name}"


def convert_postfix_array_declarations(code: str, stats: FileStats) -> str:
    output: list[str] = []
    cursor = 0
    while cursor < len(code):
        type_name, constraint, after_type = parse_type_prefix(code, cursor)
        if type_name is None:
            output.append(code[cursor])
            cursor += 1
            continue

        base_dims: list[str] = []
        after_base = skip_ws(code, after_type)
        if after_base < len(code) and code[after_base] == "[":
            base_content, maybe_after_base = read_bracket(code, after_base)
            if base_content is not None:
                base_dims = split_top_level_commas(base_content)
                after_base = maybe_after_base

        after_base = skip_ws(code, after_base)
        var_name, after_name = read_identifier(code, after_base)
        if var_name is None:
            output.append(code[cursor])
            cursor += 1
            continue

        array_dims, after_array = read_bracket_sequence(code, after_name)
        if not array_dims:
            output.append(code[cursor])
            cursor += 1
            continue

        next_index = skip_ws(code, after_array)
        if next_index < len(code) and code[next_index] not in {"=", ";", ",", ")"}:
            output.append(code[cursor])
            cursor += 1
            continue

        output.append(
            replacement_for_postfix(type_name, constraint, base_dims, var_name, array_dims, stats)
        )
        cursor = after_array
    return "".join(output)


def replace_fabs(code: str, stats: FileStats) -> str:
    output: list[str] = []
    cursor = 0
    needle = "fabs"
    while cursor < len(code):
        if (
            code.startswith(needle, cursor)
            and preceding_allows_type(code, cursor)
            and cursor + len(needle) < len(code)
            and not is_ident_char(code[cursor + len(needle)])
        ):
            stats.fabs_calls += 1
            output.append("abs")
            cursor += len(needle)
        else:
            output.append(code[cursor])
            cursor += 1
    return "".join(output)


def replace_identifier(code: str, old: str, new: str, counter_name: str, stats: FileStats) -> str:
    output: list[str] = []
    cursor = 0
    while cursor < len(code):
        if (
            code.startswith(old, cursor)
            and preceding_allows_type(code, cursor)
            and cursor + len(old) <= len(code)
            and (cursor + len(old) == len(code) or not is_ident_char(code[cursor + len(old)]))
        ):
            setattr(stats, counter_name, getattr(stats, counter_name) + 1)
            output.append(new)
            cursor += len(old)
        else:
            output.append(code[cursor])
            cursor += 1
    return "".join(output)


def find_top_level_separator(value: str) -> tuple[str | None, int | None]:
    paren_depth = 0
    bracket_depth = 0
    brace_depth = 0
    angle_depth = 0
    for index, char in enumerate(value):
        if char == "(":
            paren_depth += 1
        elif char == ")" and paren_depth:
            paren_depth -= 1
        elif char == "[":
            bracket_depth += 1
        elif char == "]" and bracket_depth:
            bracket_depth -= 1
        elif char == "{":
            brace_depth += 1
        elif char == "}" and brace_depth:
            brace_depth -= 1
        elif char == "<":
            angle_depth += 1
        elif char == ">" and angle_depth:
            angle_depth -= 1
        if paren_depth == bracket_depth == brace_depth == angle_depth == 0 and char in {",", "|"}:
            return char, index
    return None, None


def convert_probability_call_bars(code: str, stats: FileStats) -> str:
    output: list[str] = []
    cursor = 0
    suffixes = ("_lpdf", "_lpmf", "_lupdf", "_lupmf", "_cdf", "_lcdf", "_lccdf")
    while cursor < len(code):
        name, after_name = read_identifier(code, cursor)
        if not name or not any(name.endswith(suffix) for suffix in suffixes):
            output.append(code[cursor])
            cursor += 1
            continue
        line_start = code.rfind("\n", 0, cursor) + 1
        if code[line_start:cursor].strip() in TYPE_NAMES:
            output.append(code[cursor:after_name])
            cursor = after_name
            continue

        open_paren = skip_ws(code, after_name)
        if open_paren >= len(code) or code[open_paren] != "(":
            output.append(code[cursor])
            cursor += 1
            continue

        content, after_call = read_balanced(code, open_paren, "(", ")")
        if content is None:
            output.append(code[cursor])
            cursor += 1
            continue

        sep, sep_index = find_top_level_separator(content)
        if sep != "," or sep_index is None:
            output.append(code[cursor:after_call])
            cursor = after_call
            continue

        output.append(code[cursor : open_paren + 1])
        output.append(content[:sep_index].rstrip())
        output.append(" |")
        output.append(content[sep_index + 1 :])
        output.append(")")
        cursor = after_call
        stats.probability_call_bars += 1
    return "".join(output)


def repair_probability_function_signatures(code: str, stats: FileStats) -> str:
    lines: list[str] = []
    suffixes = ("_lpdf", "_lpmf", "_lupdf", "_lupmf", "_cdf", "_lcdf", "_lccdf")
    for line in code.splitlines(keepends=True):
        stripped = line.lstrip()
        if not stripped.startswith("real ") or not any(f"{suffix}(" in stripped for suffix in suffixes):
            lines.append(line)
            continue
        before_brace = line.split("{", 1)[0]
        pipe_index = before_brace.find("|")
        if pipe_index == -1:
            lines.append(line)
            continue
        line = line[:pipe_index].rstrip() + ", " + line[pipe_index + 1 :].lstrip()
        stats.probability_signature_commas += 1
        lines.append(line)
    return "".join(lines)


def add_missing_statement_semicolons(code: str, stats: FileStats) -> str:
    lines: list[str] = []
    for line in code.splitlines(keepends=True):
        newline = ""
        body = line
        if body.endswith("\n"):
            newline = "\n"
            body = body[:-1]
        if body.endswith("\r"):
            newline = "\r" + newline
            body = body[:-1]

        stripped = body.rstrip()
        trailing = body[len(stripped) :]
        if (
            stripped
            and not stripped.endswith(";")
            and ("print(" in stripped or "reject(" in stripped)
            and stripped.endswith(")")
        ):
            body = stripped + ";" + trailing
            stats.missing_semicolons += 1
        lines.append(body + newline)
    return "".join(lines)


def transform_code(code: str, stats: FileStats) -> str:
    code = repair_probability_function_signatures(code, stats)
    code = convert_unsized_array_types(code, stats)
    code = convert_postfix_array_declarations(code, stats)
    code = replace_fabs(code, stats)
    code = replace_identifier(code, "cov_exp_quad", "gp_exp_quad_cov", "cov_exp_quad_calls", stats)
    code = replace_identifier(
        code,
        "cholesky_decompose_gpu",
        "cholesky_decompose",
        "cholesky_decompose_gpu_calls",
        stats,
    )
    code = convert_probability_call_bars(code, stats)
    code = add_missing_statement_semicolons(code, stats)
    return code


def transform_preserving_comments(text: str, stats: FileStats) -> str:
    output: list[str] = []
    cursor = 0
    code_start = 0
    while cursor < len(text):
        if text.startswith("//", cursor):
            if code_start < cursor:
                output.append(transform_code(text[code_start:cursor], stats))
            newline = text.find("\n", cursor)
            if newline == -1:
                output.append(text[cursor:])
                return "".join(output)
            output.append(text[cursor : newline + 1])
            cursor = newline + 1
            code_start = cursor
            continue
        if text.startswith("/*", cursor):
            if code_start < cursor:
                output.append(transform_code(text[code_start:cursor], stats))
            end = text.find("*/", cursor + 2)
            if end == -1:
                output.append(text[cursor:])
                return "".join(output)
            output.append(text[cursor : end + 2])
            cursor = end + 2
            code_start = cursor
            continue
        cursor += 1

    if code_start < len(text):
        output.append(transform_code(text[code_start:], stats))
    return "".join(output)


def modernize_text(text: str) -> tuple[str, FileStats]:
    stats = FileStats()
    text = convert_hash_comments(text, stats)
    text = transform_preserving_comments(text, stats)
    return text, stats


def iter_model_paths(models_root: Path) -> list[Path]:
    return sorted(models_root.glob("*/*/model.stan"))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models-root", type=Path, default=DEFAULT_MODELS_ROOT)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    total = FileStats()
    changed_paths: list[Path] = []
    for path in iter_model_paths(args.models_root):
        original = path.read_text(encoding="utf-8")
        updated, stats = modernize_text(original)
        if updated == original:
            continue
        changed_paths.append(path)
        total += stats
        if not args.dry_run:
            path.write_text(updated, encoding="utf-8")

    print(f"models scanned: {len(iter_model_paths(args.models_root))}")
    print(f"files changed: {len(changed_paths)}")
    print(f"hash comments converted: {total.hash_comments}")
    print(f"unsized array types converted: {total.unsized_arrays}")
    print(f"postfix arrays converted: {total.postfix_arrays}")
    print(f"shaped type dimensions converted: {total.shaped_type_dims}")
    print(f"fabs calls converted: {total.fabs_calls}")
    print(f"cov_exp_quad calls converted: {total.cov_exp_quad_calls}")
    print(f"cholesky_decompose_gpu calls converted: {total.cholesky_decompose_gpu_calls}")
    print(f"probability call bars inserted: {total.probability_call_bars}")
    print(f"probability signature commas restored: {total.probability_signature_commas}")
    print(f"missing semicolons inserted: {total.missing_semicolons}")
    if args.dry_run and changed_paths:
        print("dry run only; no files written")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
