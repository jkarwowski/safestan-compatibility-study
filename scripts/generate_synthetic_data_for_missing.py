#!/usr/bin/env python3
"""Generate synthetic data for model dirs with placeholder data.

This is a pragmatic data-block driven generator. It is intended for imported
model corpora where upstream data is unavailable or intentionally omitted. The
generated data is small, positive where constrained, and shaped according to the
Stan data declarations.
"""

from __future__ import annotations

import argparse
import ast
import json
import math
import os
import re
import shutil
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_MODELS_ROOT = ROOT / "models"
GENERATOR_ID = "synthetic_data_for_missing_v2"

COMMENT_BLOCK_RE = re.compile(r"/\*.*?\*/", re.DOTALL)
COMMENT_LINE_RE = re.compile(r"//.*?$", re.MULTILINE)
COMMENT_HASH_RE = re.compile(r"#(?!include).*$", re.MULTILINE)
DATA_BLOCK_RE = re.compile(r"\bdata\s*\{", re.MULTILINE)


@dataclass
class Declaration:
    name: str
    base_type: str
    base_dims: list[str]
    array_dims: list[str]
    lower: str | None
    upper: str | None
    statement: str


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, value: Any) -> None:
    with path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2, sort_keys=True)
        handle.write("\n")


def strip_comments(text: str) -> str:
    text = COMMENT_BLOCK_RE.sub("", text)
    text = COMMENT_LINE_RE.sub("", text)
    text = COMMENT_HASH_RE.sub("", text)
    return text


def extract_data_block(stan_text: str) -> str | None:
    text = strip_comments(stan_text)
    match = None
    for candidate in DATA_BLOCK_RE.finditer(text):
        if text[: candidate.start()].rstrip().endswith("transformed"):
            continue
        match = candidate
        break
    if not match:
        return None
    depth = 1
    start = match.end()
    index = start
    while index < len(text):
        char = text[index]
        if char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return text[start:index]
        index += 1
    return None


def split_statements(block: str) -> list[str]:
    statements: list[str] = []
    current: list[str] = []
    angle_depth = 0
    bracket_depth = 0
    paren_depth = 0
    for char in block:
        if char == "<":
            angle_depth += 1
        elif char == ">" and angle_depth:
            angle_depth -= 1
        elif char == "[":
            bracket_depth += 1
        elif char == "]" and bracket_depth:
            bracket_depth -= 1
        elif char == "(":
            paren_depth += 1
        elif char == ")" and paren_depth:
            paren_depth -= 1
        if char == ";" and angle_depth == bracket_depth == paren_depth == 0:
            statement = " ".join("".join(current).split())
            if statement:
                statements.append(statement)
            current = []
        else:
            current.append(char)
    return statements


def split_top_level_commas(value: str) -> list[str]:
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
    if tail:
        parts.append(tail)
    return parts


def parse_constraints(value: str) -> tuple[str | None, str | None, str]:
    if not value.startswith("<"):
        return None, None, value
    depth = 0
    end = -1
    for index, char in enumerate(value):
        if char == "<":
            depth += 1
        elif char == ">":
            depth -= 1
            if depth == 0:
                end = index
                break
    if end == -1:
        return None, None, value
    lower = None
    upper = None
    content = value[1:end]
    for part in split_top_level_commas(content):
        if "=" not in part:
            continue
        key, raw = [item.strip() for item in part.split("=", 1)]
        if key == "lower":
            lower = raw
        elif key == "upper":
            upper = raw
    return lower, upper, value[end + 1 :].strip()


def read_bracket_expr(value: str, start: int) -> tuple[str, int]:
    assert value[start] == "["
    depth = 1
    current: list[str] = []
    index = start + 1
    while index < len(value):
        char = value[index]
        if char == "[":
            depth += 1
        elif char == "]":
            depth -= 1
            if depth == 0:
                return "".join(current), index + 1
        current.append(char)
        index += 1
    raise ValueError(f"unclosed dimension bracket in {value!r}")


def parse_sized_type(value: str) -> tuple[str, list[str], str]:
    match = re.match(r"([A-Za-z_]\w*)\s*", value)
    if not match:
        raise ValueError(f"could not parse type in {value!r}")
    base_type = match.group(1)
    index = match.end()
    base_dims: list[str] = []
    if index < len(value) and value[index] == "[":
        raw_dims, index = read_bracket_expr(value, index)
        base_dims = split_top_level_commas(raw_dims)
    return base_type, base_dims, value[index:].strip()


def parse_base_after_constraints(type_name: str, rest: str) -> tuple[str, list[str], str]:
    base_dims: list[str] = []
    if rest.startswith("["):
        raw_dims, after = read_bracket_expr(rest, 0)
        base_dims = split_top_level_commas(raw_dims)
        rest = rest[after:].strip()
    return type_name, base_dims, rest


def parse_new_array(statement: str) -> Declaration | None:
    if not statement.startswith("array"):
        return None
    array_dims_raw, index = read_bracket_expr(statement, len("array"))
    rest = statement[index:].strip()
    match = re.match(r"([A-Za-z_]\w*)", rest)
    if not match:
        return None
    type_name = match.group(1)
    rest = rest[match.end() :].strip()
    lower, upper, rest = parse_constraints(rest)
    base_type, base_dims, rest = parse_base_after_constraints(type_name, rest)
    name_match = re.match(r"([A-Za-z_]\w*)$", rest)
    if not name_match:
        return None
    return Declaration(
        name=name_match.group(1),
        base_type=base_type,
        base_dims=base_dims,
        array_dims=split_top_level_commas(array_dims_raw),
        lower=lower,
        upper=upper,
        statement=statement,
    )


def parse_old_or_scalar(statement: str) -> Declaration | None:
    match = re.match(r"([A-Za-z_]\w*)", statement)
    if not match:
        return None
    type_name = match.group(1)
    rest = statement[match.end() :].strip()
    lower, upper, rest = parse_constraints(rest)
    base_type, base_dims, rest = parse_base_after_constraints(type_name, rest)
    name_match = re.match(r"([A-Za-z_]\w*)", rest)
    if not name_match:
        return None
    name = name_match.group(1)
    rest = rest[name_match.end() :].strip()
    array_dims: list[str] = []
    if rest.startswith("["):
        raw_dims, after = read_bracket_expr(rest, 0)
        array_dims = split_top_level_commas(raw_dims)
        rest = rest[after:].strip()
    if rest:
        return None
    return Declaration(
        name=name,
        base_type=base_type,
        base_dims=base_dims,
        array_dims=array_dims,
        lower=lower,
        upper=upper,
        statement=statement,
    )


def parse_declaration(statement: str) -> Declaration | None:
    if any(token in statement for token in ("~", "for ", "while ", "if ")):
        return None
    if re.search(r"(?<![<>])=(?![<>])", statement) and not re.search(r"<[^>]*=", statement):
        return None
    return parse_new_array(statement) or parse_old_or_scalar(statement)


def one_based_index(value: Any, indexes: list[int]) -> Any:
    result = value
    for index in indexes:
        if not isinstance(result, list) or not result:
            return 1
        index = max(1, min(index, len(result)))
        result = result[index - 1]
    return result


class SafeEvaluator(ast.NodeVisitor):
    def __init__(self, env: dict[str, Any]):
        self.env = env

    def visit_Expression(self, node: ast.Expression) -> Any:
        return self.visit(node.body)

    def visit_Constant(self, node: ast.Constant) -> Any:
        if isinstance(node.value, (int, float)):
            return node.value
        raise ValueError("unsupported constant")

    def visit_Name(self, node: ast.Name) -> Any:
        if node.id in self.env:
            return self.env[node.id]
        raise ValueError(f"unknown name {node.id}")

    def visit_UnaryOp(self, node: ast.UnaryOp) -> Any:
        operand = self.visit(node.operand)
        if isinstance(node.op, ast.USub):
            return -operand
        if isinstance(node.op, ast.UAdd):
            return operand
        raise ValueError("unsupported unary op")

    def visit_BinOp(self, node: ast.BinOp) -> Any:
        left = self.visit(node.left)
        right = self.visit(node.right)
        if isinstance(node.op, ast.Add):
            return left + right
        if isinstance(node.op, ast.Sub):
            return left - right
        if isinstance(node.op, ast.Mult):
            return left * right
        if isinstance(node.op, ast.Div):
            return left / right
        if isinstance(node.op, ast.FloorDiv):
            return left // right
        if isinstance(node.op, ast.Mod):
            return left % right
        if isinstance(node.op, ast.Pow):
            return left**right
        raise ValueError("unsupported binary op")

    def visit_Subscript(self, node: ast.Subscript) -> Any:
        value = self.visit(node.value)
        if isinstance(node.slice, ast.Tuple):
            indexes = [int(self.visit(item)) for item in node.slice.elts]
        else:
            indexes = [int(self.visit(node.slice))]
        return one_based_index(value, indexes)

    def visit_Call(self, node: ast.Call) -> Any:
        if not isinstance(node.func, ast.Name):
            raise ValueError("unsupported call")
        name = node.func.id
        args = [self.visit(arg) for arg in node.args]
        if name in {"sum", "max", "min"}:
            func = {"sum": sum, "max": max, "min": min}[name]
            return func(args[0])
        if name in {"size", "num_elements", "rows", "cols"}:
            value = args[0]
            if name == "rows":
                return len(value)
            if name == "cols":
                return len(value[0]) if value and isinstance(value[0], list) else len(value)
            return len(value)
        if name in {"int_step", "step"}:
            return 1 if args[0] >= 0 else 0
        raise ValueError(f"unsupported call {name}")

    def generic_visit(self, node: ast.AST) -> Any:
        raise ValueError(f"unsupported expression node {type(node).__name__}")


def stan_expr_to_python(expr: str) -> str:
    expr = expr.strip()
    expr = expr.replace("^", "**")
    expr = re.sub(r"\bpositive_infinity\s*\(\s*\)", "1e6", expr)
    expr = re.sub(r"\bnegative_infinity\s*\(\s*\)", "-1e6", expr)
    expr = re.sub(r"\binf(inity)?\b", "1e6", expr)
    return expr


def eval_expr(expr: str | None, env: dict[str, Any], default: float = 1.0) -> float:
    if expr is None or not str(expr).strip():
        return default
    expr = stan_expr_to_python(str(expr))
    try:
        parsed = ast.parse(expr, mode="eval")
        value = SafeEvaluator(env).visit(parsed)
    except Exception:
        return default
    if isinstance(value, list):
        return float(value[0] if value else default)
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def eval_dim(expr: str, env: dict[str, Any]) -> int:
    value = int(round(eval_expr(expr, env, 2)))
    return max(value, 0)


def is_dimension_name(name: str) -> bool:
    lowered = name.lower()
    return bool(
        re.match(r"^(n|n_|num_|nnum|j$|k$|m$|i$|t$|p$|q$|d$|c$|l_)", lowered)
        or lowered in {"rows", "cols", "schools", "players", "teams"}
        or "levels" in lowered
        or "size" in lowered
    )


def preferred_dimension_value(name: str, lower: int | None, upper: int | None) -> int:
    lowered = name.lower()
    value = 4
    if any(token in lowered for token in ("pred", "predict", "grid", "display", "edges")):
        value = 3
    if any(token in lowered for token in ("factor", "level", "team", "site", "state", "group", "item", "subj", "person", "county")):
        value = 3
    if any(token in lowered for token in ("mis", "missing", "cens", "edge", "occasion")):
        value = 2
    if lowered in {"k", "j", "m", "i", "p", "q", "d", "c"}:
        value = 3
    if lower is not None:
        value = max(value, lower)
    if upper is not None:
        value = min(value, upper)
    if lower is not None:
        value = max(value, lower)
    return max(value, 0)


def integer_value(name: str, lower_expr: str | None, upper_expr: str | None, env: dict[str, Any], index: int) -> int:
    lower = int(math.ceil(eval_expr(lower_expr, env, 0))) if lower_expr is not None else None
    upper = int(math.floor(eval_expr(upper_expr, env, 0))) if upper_expr is not None else None
    if lower is not None and upper is not None and upper < lower:
        upper = lower

    lowered = name.lower()
    if is_dimension_name(name) and not any(token in lowered for token in ("idx", "index", "node", "team_", "site_", "year_")):
        return preferred_dimension_value(name, lower, upper)

    if upper is not None and lower is not None:
        if upper == lower:
            return upper
        if upper == 1 and lower <= 0:
            return index % 2
        return min(upper, max(lower, 1 + (index % max(1, upper - lower + 1))))
    if upper is not None:
        if upper <= 0:
            return upper
        return min(upper, 1 + (index % max(1, upper)))
    if lower is not None:
        if lower <= 0:
            if any(token in lowered for token in ("y", "obs", "count", "success", "complaint", "goal")):
                return 1
            return max(lower, 1)
        return lower
    if any(token in lowered for token in ("idx", "index", "node", "team", "site", "year", "person", "county", "state")):
        return 1
    if any(token in lowered for token in ("y", "obs", "count", "success", "complaint", "goal", "winner")):
        return 1
    return 1


def real_value(name: str, lower_expr: str | None, upper_expr: str | None, env: dict[str, Any], index: int) -> float:
    lower = eval_expr(lower_expr, env, 0.0) if lower_expr is not None else None
    upper = eval_expr(upper_expr, env, 0.0) if upper_expr is not None else None
    if lower is not None and upper is not None and upper < lower:
        upper = lower
    lowered = name.lower()
    if any(token in lowered for token in ("time", "times", "t_", "ts", "grid", "distance", "height", "age")):
        value = 0.5 + 0.5 * index
    elif any(token in lowered for token in ("sigma", "sd", "scale", "rho", "tau", "alpha", "beta", "gamma", "lambda", "rate", "traps", "exposure", "e_")):
        value = 1.0
    elif any(token in lowered for token in ("left", "lower", "min")):
        value = 0.0
    elif any(token in lowered for token in ("right", "upper", "max")):
        value = 1.0
    else:
        value = 0.1 * ((index % 7) + 1)
    if lower is not None:
        value = max(value, lower)
        if lower == 0 and value == 0:
            value = 0.1
    if upper is not None:
        value = min(value, upper)
    if lower is not None and upper is not None and value == upper == lower:
        return float(value)
    return float(value)


def nested_array(shape: list[int], factory: Any, offset: int = 0) -> Any:
    if not shape:
        return factory(offset)
    size = shape[0]
    return [nested_array(shape[1:], factory, offset * max(size, 1) + index) for index in range(size)]


def identity_matrix(size: int) -> list[list[float]]:
    return [[1.0 if row == col else 0.0 for col in range(size)] for row in range(size)]


def base_value(decl: Declaration, env: dict[str, Any], index: int = 0) -> Any:
    base_type = decl.base_type
    dims = [eval_dim(expr, env) for expr in decl.base_dims]
    if base_type == "int":
        return integer_value(decl.name, decl.lower, decl.upper, env, index)
    if base_type == "real":
        return real_value(decl.name, decl.lower, decl.upper, env, index)
    if base_type in {"vector", "row_vector"}:
        size = dims[0] if dims else 1
        return [real_value(decl.name, decl.lower, decl.upper, env, index + i) for i in range(size)]
    if base_type == "matrix":
        rows = dims[0] if dims else 1
        cols = dims[1] if len(dims) > 1 else rows
        return [
            [real_value(decl.name, decl.lower, decl.upper, env, index + row * cols + col) for col in range(cols)]
            for row in range(rows)
        ]
    if base_type in {"cov_matrix", "corr_matrix", "cholesky_factor_cov", "cholesky_factor_corr"}:
        size = dims[0] if dims else 1
        return identity_matrix(size)
    if base_type == "simplex":
        size = max(dims[0] if dims else 1, 1)
        return [1.0 / size for _ in range(size)]
    if base_type == "unit_vector":
        size = max(dims[0] if dims else 1, 1)
        value = 1.0 / math.sqrt(size)
        return [value for _ in range(size)]
    if base_type in {"ordered", "positive_ordered"}:
        size = dims[0] if dims else 1
        start = 1.0 if base_type == "positive_ordered" else 0.0
        return [start + i for i in range(size)]
    return real_value(decl.name, decl.lower, decl.upper, env, index)


def declaration_value(decl: Declaration, env: dict[str, Any]) -> Any:
    outer_shape = [eval_dim(expr, env) for expr in decl.array_dims]
    if not outer_shape:
        return base_value(decl, env)
    return nested_array(outer_shape, lambda offset: base_value(decl, env, offset))


def declaration_shape(decl: Declaration, env: dict[str, Any]) -> list[int]:
    shape = [eval_dim(expr, env) for expr in decl.array_dims]
    if decl.base_type in {"vector", "row_vector", "simplex", "unit_vector", "ordered", "positive_ordered"}:
        shape.append(eval_dim(decl.base_dims[0], env) if decl.base_dims else 1)
    elif decl.base_type in {"matrix", "cov_matrix", "corr_matrix", "cholesky_factor_cov", "cholesky_factor_corr"}:
        rows = eval_dim(decl.base_dims[0], env) if decl.base_dims else 1
        cols = eval_dim(decl.base_dims[1], env) if len(decl.base_dims) > 1 else rows
        shape.extend([rows, cols])
    return shape


def coerce_leaf(value: Any, decl: Declaration, env: dict[str, Any], index: int) -> Any:
    if decl.base_type == "int":
        lower = int(math.ceil(eval_expr(decl.lower, env, 0))) if decl.lower is not None else None
        upper = int(math.floor(eval_expr(decl.upper, env, 0))) if decl.upper is not None else None
        try:
            coerced = int(round(float(value)))
        except (TypeError, ValueError):
            coerced = integer_value(decl.name, decl.lower, decl.upper, env, index)
        if lower is not None:
            coerced = max(coerced, lower)
        if upper is not None:
            coerced = min(coerced, upper)
        return coerced
    try:
        coerced_real = float(value)
    except (TypeError, ValueError):
        coerced_real = real_value(decl.name, decl.lower, decl.upper, env, index)
    lower = eval_expr(decl.lower, env, 0.0) if decl.lower is not None else None
    upper = eval_expr(decl.upper, env, 0.0) if decl.upper is not None else None
    if lower is not None:
        coerced_real = max(coerced_real, lower)
    if upper is not None:
        coerced_real = min(coerced_real, upper)
    return coerced_real


def coerce_shape(value: Any, shape: list[int], decl: Declaration, env: dict[str, Any], offset: int = 0) -> Any:
    if not shape:
        return coerce_leaf(value, decl, env, offset)
    existing = value if isinstance(value, list) else []
    size = max(shape[0], 0)
    return [
        coerce_shape(
            existing[index] if index < len(existing) else None,
            shape[1:],
            decl,
            env,
            offset * max(size, 1) + index,
        )
        for index in range(size)
    ]


def map_nested(value: Any, func: Any) -> Any:
    if isinstance(value, list):
        return [map_nested(item, func) for item in value]
    return func(value)


def clamp_nested(value: Any, lower: int, upper: int) -> Any:
    return map_nested(value, lambda item: max(lower, min(upper, int(round(float(item)))) if isinstance(item, (int, float)) else lower))


def clamp_successes(successes: Any, trials: Any) -> Any:
    if isinstance(successes, list):
        if isinstance(trials, list):
            return [
                clamp_successes(item, trials[index] if index < len(trials) else trials[-1] if trials else 0)
                for index, item in enumerate(successes)
            ]
        return [clamp_successes(item, trials) for item in successes]
    try:
        n = int(round(float(trials[0] if isinstance(trials, list) and trials else trials)))
        y = int(round(float(successes)))
    except (TypeError, ValueError):
        return 0
    return max(0, min(y, max(n, 0)))


def max_indexed_position(stan_text: str, name: str) -> int | None:
    positions = [int(match.group(1)) for match in re.finditer(rf"\b{re.escape(name)}\s*\[\s*(\d+)\s*\]", stan_text)]
    return max(positions) if positions else None


def parse_data_declarations(model_dir: Path) -> list[Declaration]:
    text = (model_dir / "model.stan").read_text(encoding="utf-8", errors="replace")
    block = extract_data_block(text)
    if block is None:
        return []
    declarations: list[Declaration] = []
    for statement in split_statements(block):
        decl = parse_declaration(statement)
        if decl is not None:
            declarations.append(decl)
    return declarations


def fit_payload_to_declarations(payload: dict[str, Any], declarations: list[Declaration]) -> None:
    env: dict[str, Any] = dict(payload)
    for decl in declarations:
        if decl.name not in payload:
            payload[decl.name] = declaration_value(decl, env)
        shape = declaration_shape(decl, env)
        if shape:
            payload[decl.name] = coerce_shape(payload[decl.name], shape, decl, env)
        elif decl.base_type in {"int", "real"}:
            payload[decl.name] = coerce_leaf(payload[decl.name], decl, env, 0)
        env[decl.name] = payload[decl.name]


def repair_dimension_payload(payload: dict[str, Any], declarations: list[Declaration], stan_text: str) -> None:
    declared = {decl.name: decl for decl in declarations}
    stripped = strip_comments(stan_text)
    sized_patterns = [
        re.compile(r"\barray\s*\[\s*([A-Za-z_]\w*)\s*\]\s+[A-Za-z_]\w*(?:\s*<[^>]*>)?(?:\s*\[[^\]]+\])?\s+([A-Za-z_]\w*)"),
        re.compile(r"\b(?:vector|row_vector)\s*\[\s*([A-Za-z_]\w*)\s*\]\s+([A-Za-z_]\w*)"),
        re.compile(r"\bmatrix\s*\[\s*([A-Za-z_]\w*)\s*,\s*([A-Za-z_]\w*)\s*\]\s+([A-Za-z_]\w*)"),
    ]
    for pattern in sized_patterns:
        for match in pattern.finditer(stripped):
            groups = match.groups()
            if len(groups) == 2:
                dim_names = [groups[0]]
                var_name = groups[1]
            else:
                dim_names = [groups[0], groups[1]]
                var_name = groups[2]
            max_position = max_indexed_position(stan_text, var_name)
            if max_position is None:
                continue
            for dim_name in dim_names:
                if dim_name in payload and isinstance(payload[dim_name], (int, float)):
                    payload[dim_name] = max(int(payload[dim_name]), max_position)
    for decl in declarations:
        max_position = max_indexed_position(stan_text, decl.name)
        if max_position is None:
            continue
        for dim_expr in decl.array_dims:
            dim_name = dim_expr.strip()
            if re.fullmatch(r"[A-Za-z_]\w*", dim_name) and dim_name in payload:
                try:
                    payload[dim_name] = max(int(payload[dim_name]), max_position)
                except (TypeError, ValueError):
                    payload[dim_name] = max_position
    for name in ("J", "K", "G", "M"):
        max_position = max_indexed_position(stan_text, name)
        if max_position is None:
            continue
        if name in payload and isinstance(payload[name], (int, float)):
            payload[name] = max(int(payload[name]), max_position)
        elif name in declared:
            payload[name] = max_position
    if "N" in payload and "N_obs" in payload:
        try:
            payload["N"] = max(int(payload["N"]), int(payload["N_obs"]) + 1)
        except (TypeError, ValueError):
            pass
    if "N" in payload and "N_train" in payload:
        try:
            payload["N_train"] = min(int(payload["N_train"]), int(payload["N"]))
        except (TypeError, ValueError):
            pass


def repair_index_payload(payload: dict[str, Any], declarations: list[Declaration]) -> None:
    env = dict(payload)
    for decl in declarations:
        if decl.base_type != "int" or decl.name not in payload:
            continue
        lowered = decl.name.lower()
        if "start_idx" in lowered or "end_idx" in lowered or lowered.startswith("packed_"):
            continue
        looks_like_index = bool(
            lowered.endswith("idx")
            or lowered.endswith("idxs")
            or lowered.endswith("_ind")
            or "index" in lowered
            or lowered
            in {
                "county",
                "village",
                "city",
                "year",
                "site",
                "state",
                "team",
                "person",
                "cond",
                "slim",
                "sign",
                "lght",
                "blte",
                "tffc",
                "ind",
            }
        )
        if not looks_like_index:
            continue
        lower = int(math.ceil(eval_expr(decl.lower, env, 1))) if decl.lower is not None else 1
        upper = int(math.floor(eval_expr(decl.upper, env, lower))) if decl.upper is not None else lower
        if upper < lower:
            upper = lower
        preferred = 2 if "idx" in lowered and upper >= max(lower, 2) else lower
        payload[decl.name] = clamp_nested(payload[decl.name], lower, upper)
        payload[decl.name] = map_nested(payload[decl.name], lambda _: preferred)

    if {"N", "N_obs", "obs_idx", "unobs_idx"}.issubset(payload):
        try:
            n = int(payload["N"])
            n_obs = min(max(1, int(payload["N_obs"])), max(n - 1, 1))
        except (TypeError, ValueError):
            return
        payload["N_obs"] = n_obs
        payload["obs_idx"] = list(range(2, 2 + n_obs))
        payload["unobs_idx"] = list(range(2 + n_obs, n + 2))
    if {"N", "left_idxs", "center_idxs", "right_idxs"}.issubset(payload):
        try:
            n = max(3, int(payload["N"]))
        except (TypeError, ValueError):
            n = 3
        count = max(n - 2, 1)
        payload["N"] = n
        payload["left_idxs"] = [1 for _ in range(count)]
        payload["center_idxs"] = [min(n - 1, 2 + index) for index in range(count)]
        payload["right_idxs"] = [n for _ in range(count)]
    if "obs_idxs" in payload and "N" in payload:
        try:
            n = max(1, int(payload["N"]))
        except (TypeError, ValueError):
            n = 1
        value = payload["obs_idxs"]
        if isinstance(value, list):
            payload["obs_idxs"] = [min(n, max(1, 1 + (index % n))) for index, _ in enumerate(value)]


def repair_factor_payload(payload: dict[str, Any]) -> None:
    for prefix in ("main", "inter1", "inter2"):
        factors_key = f"N_{prefix}_factors"
        levels_key = f"N_{prefix}_factor_levels"
        all_levels_key = f"N_all_{prefix}_factor_levels"
        start_key = f"{prefix}_factor_start_idx"
        end_key = f"{prefix}_factor_end_idx"
        packed_key = f"packed_{prefix}_factor_idx"
        level_idx_key = f"{prefix}_factor_level_idx"
        if factors_key not in payload or levels_key not in payload:
            continue
        try:
            n_factors = max(1, int(payload[factors_key]))
        except (TypeError, ValueError):
            n_factors = 1
        levels_raw = payload.get(levels_key)
        levels = levels_raw if isinstance(levels_raw, list) else []
        levels = [max(1, int(round(float(levels[index])))) if index < len(levels) else 1 for index in range(n_factors)]
        total = sum(levels)
        starts: list[int] = []
        ends: list[int] = []
        packed: list[int] = []
        cursor = 1
        for factor, count in enumerate(levels, 1):
            starts.append(cursor)
            ends.append(cursor + count - 1)
            packed.extend([factor] * count)
            cursor += count
        n = max(0, int(payload.get("N", 0) or 0))
        payload[factors_key] = n_factors
        payload[levels_key] = levels
        payload[all_levels_key] = total
        payload[start_key] = starts
        payload[end_key] = ends
        payload[packed_key] = packed
        if level_idx_key in payload:
            payload[level_idx_key] = [[1 for _ in range(n)] for _ in range(n_factors)]


def repair_threshold_payload(payload: dict[str, Any]) -> None:
    if {"t1", "t2", "t3"}.issubset(payload):
        payload["t1"] = 1.0
        payload["t2"] = 2.0
        payload["t3"] = 3.0


def repair_square_matrix_payload(payload: dict[str, Any]) -> None:
    for key, value in list(payload.items()):
        if not isinstance(value, list) or not value or not all(isinstance(row, list) for row in value):
            continue
        rows = len(value)
        cols = len(value[0]) if value and value[0] else 0
        if rows != cols:
            continue
        lowered = key.lower()
        if lowered in {"w", "sigma", "omega", "cov", "corr", "r"} or any(
            token in lowered for token in ("cov", "corr", "omega", "wishart")
        ):
            payload[key] = identity_matrix(rows)


def repair_component_sizes(payload: dict[str, Any]) -> None:
    if "component_sizes" not in payload or "N" not in payload:
        return
    sizes = payload["component_sizes"]
    if not isinstance(sizes, list) or not sizes:
        return
    try:
        n = max(1, int(payload["N"]))
    except (TypeError, ValueError):
        return
    sizes = [max(1, int(round(float(item)))) for item in sizes]
    if sum(sizes) > n:
        payload["N"] = sum(sizes)
    payload["component_sizes"] = sizes


def repair_binomial_payload(payload: dict[str, Any], stan_text: str) -> None:
    pairs: set[tuple[str, str]] = set()
    sampling_pattern = re.compile(r"\b([A-Za-z_]\w*)\s*(?:\[[^\]]+\])?\s*~\s*binomial(?:_logit)?\s*\(\s*([A-Za-z_]\w*)")
    lpmf_pattern = re.compile(r"\bbinomial(?:_logit)?_lu?pmf\s*\(\s*([A-Za-z_]\w*)\s*(?:\[[^\]]+\])?\s*\|\s*([A-Za-z_]\w*)")
    pairs.update((match.group(1), match.group(2)) for match in sampling_pattern.finditer(stan_text))
    pairs.update((match.group(1), match.group(2)) for match in lpmf_pattern.finditer(stan_text))
    for key in payload:
        if not key.startswith("y"):
            continue
        suffix = key[1:]
        for trial_key in (f"n{suffix}", f"N{suffix}", f"trials{suffix}"):
            if trial_key in payload:
                pairs.add((key, trial_key))
    for key in payload:
        lowered = key.lower()
        if any(token in lowered for token in ("success", "pos_", "positive")):
            for trial_key in ("n", "N", "trials", "tests", f"n_{key}", f"n{key}"):
                if trial_key in payload:
                    pairs.add((key, trial_key))
        if any(token in lowered for token in ("redcard", "success", "positive")) and "n_games" in payload:
            pairs.add((key, "n_games"))
    if "y" in payload and "N" in payload and "binomial" in stan_text:
        pairs.add(("y", "N"))
    for successes, trials in pairs:
        if successes in payload and trials in payload:
            payload[successes] = clamp_successes(payload[successes], payload[trials])


def repair_time_payload(payload: dict[str, Any]) -> None:
    if "t0" in payload and any(key.lower() in {"t", "ts", "time", "times"} for key in payload):
        payload["t0"] = 0.0
    for key, value in list(payload.items()):
        lowered = key.lower()
        if isinstance(value, list) and all(isinstance(item, (int, float)) for item in value):
            if lowered in {"t", "time", "times", "ts"} or any(
                token in lowered for token in ("time", "times", "grid", "x_grid", "x_predict")
            ):
                payload[key] = [1.0 + index for index in range(len(value))]


def postprocess_payload(payload: dict[str, Any], model_dir: Path | None = None) -> None:
    stan_text = (model_dir / "model.stan").read_text(encoding="utf-8", errors="replace") if model_dir else ""
    declarations = parse_data_declarations(model_dir) if model_dir else []
    allowed = {decl.name for decl in declarations}
    if allowed:
        for key in list(payload):
            if key not in allowed:
                del payload[key]
        fit_payload_to_declarations(payload, declarations)
        repair_dimension_payload(payload, declarations, stan_text)
        fit_payload_to_declarations(payload, declarations)
        repair_factor_payload(payload)
        repair_component_sizes(payload)
        repair_threshold_payload(payload)
        repair_square_matrix_payload(payload)
        fit_payload_to_declarations(payload, declarations)
        repair_index_payload(payload, declarations)
        fit_payload_to_declarations(payload, declarations)
        repair_binomial_payload(payload, stan_text)
        repair_time_payload(payload)
        fit_payload_to_declarations(payload, declarations)
    for key in list(payload):
        lowered = key.lower()
        value = payload[key]
        if isinstance(value, list) and (
            lowered in {"t", "time", "times", "ts"}
            or any(token in lowered for token in ("time", "times", "grid", "x_grid", "x_predict"))
        ):
            if value and all(isinstance(item, (int, float)) for item in value):
                payload[key] = [1.0 + index for index in range(len(value))]
        if lowered in {"node1", "node2"} and isinstance(value, list):
            n = int(payload.get("N", payload.get("n", 3)) or 3)
            if lowered == "node1":
                payload[key] = [1 for _ in value]
            else:
                payload[key] = [2 if n >= 2 else 1 for _ in value]
        if lowered in {"y", "successes", "success", "complaints"} and isinstance(value, list):
            trials = payload.get("n") or payload.get("trials") or payload.get("N_trials")
            if isinstance(trials, list):
                payload[key] = [
                    min(int(y), int(trials[index]) if index < len(trials) else int(y))
                    for index, y in enumerate(value)
                    if isinstance(y, (int, float))
                ]
    if declarations:
        fit_payload_to_declarations(payload, declarations)


def generated_data_with_stanc(model_dir: Path, stanc: Path | None) -> tuple[dict[str, Any] | None, dict[str, Any]]:
    stats: dict[str, Any] = {
        "method": "stanc_debug_generate_data",
        "stanc_path": str(stanc) if stanc else None,
    }
    if stanc is None:
        stats["stanc_error"] = "no_stanc_found"
        return None, stats
    command = [
        str(stanc),
        "--allow-undefined",
        "--debug-generate-data",
        str(model_dir / "model.stan"),
    ]
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if result.returncode != 0:
        stats["stanc_error"] = result.stderr.strip().splitlines()[0] if result.stderr.strip() else f"exit_{result.returncode}"
        return None, stats
    try:
        payload = json.loads(result.stdout)
    except json.JSONDecodeError as error:
        stats["stanc_error"] = f"invalid_json:{error}"
        return None, stats
    if not isinstance(payload, dict):
        stats["stanc_error"] = "stanc_generated_non_object_json"
        return None, stats
    postprocess_payload(payload, model_dir)
    stats["declarations"] = len(payload)
    stats["had_data_block"] = bool(payload)
    stats["unparsed_statements"] = []
    return payload, stats


def generate_with_fallback_parser(model_dir: Path) -> tuple[dict[str, Any], dict[str, Any]]:
    text = (model_dir / "model.stan").read_text(encoding="utf-8", errors="replace")
    block = extract_data_block(text)
    payload: dict[str, Any] = {}
    stats: dict[str, Any] = {
        "declarations": 0,
        "unparsed_statements": [],
        "had_data_block": block is not None,
    }
    if block is not None:
        for statement in split_statements(block):
            decl = parse_declaration(statement)
            if decl is None:
                stats["unparsed_statements"].append(statement)
                continue
            value = declaration_value(decl, payload)
            payload[decl.name] = value
            stats["declarations"] += 1
    postprocess_payload(payload, model_dir)
    return payload, stats


def generate_for_model(model_dir: Path, stanc: Path | None) -> tuple[dict[str, Any], dict[str, Any]]:
    payload, stanc_stats = generated_data_with_stanc(model_dir, stanc)
    if payload is not None:
        return payload, stanc_stats
    fallback_payload, fallback_stats = generate_with_fallback_parser(model_dir)
    fallback_stats["method"] = "data_block_parser_fallback"
    fallback_stats["stanc_path"] = stanc_stats.get("stanc_path")
    fallback_stats["stanc_error"] = stanc_stats.get("stanc_error")
    return fallback_payload, fallback_stats


def append_source_note(model_dir: Path, stats: dict[str, Any]) -> None:
    path = model_dir / "source.md"
    if not path.exists():
        return
    text = path.read_text(encoding="utf-8").rstrip()
    marker = "## Synthetic Data"
    section = (
        f"\n\n{marker}\n\n"
        f"- Data status: synthetic/local generated by `{Path(__file__).name}`.\n"
        f"- Generation method: {stats['method']}.\n"
        f"- Parsed data declarations: {stats['declarations']}.\n"
        f"- Data block present: {str(stats['had_data_block']).lower()}."
    )
    if stats.get("stanc_error"):
        section += f"\n- stanc fallback reason: {stats['stanc_error']}."
    if marker in text:
        text = text.split(marker, 1)[0].rstrip()
    path.write_text(text + section + "\n", encoding="utf-8")


def update_metadata(model_dir: Path, stats: dict[str, Any]) -> None:
    path = model_dir / "metadata.json"
    metadata = load_json(path)
    previous = {
        "data_source": metadata.get("data_source"),
        "data_status": metadata.get("data_status"),
        "data_placeholder": metadata.get("data_placeholder"),
        "upstream_data_bytes": metadata.get("upstream_data_bytes"),
    }
    metadata["data_source"] = "synthetic/local"
    metadata["data_status"] = "synthetic_generated"
    metadata["data_placeholder"] = False
    metadata["synthetic_data_generator"] = GENERATOR_ID
    metadata["synthetic_data_method"] = stats["method"]
    metadata["synthetic_data_note"] = (
        "Generated small synthetic data from stanc or the Stan data block because upstream data was missing or omitted."
    )
    metadata["synthetic_data_declarations"] = stats["declarations"]
    metadata["synthetic_data_had_data_block"] = stats["had_data_block"]
    metadata["previous_data_metadata"] = {key: value for key, value in previous.items() if value is not None}
    if stats["unparsed_statements"]:
        metadata["synthetic_data_unparsed_statements"] = stats["unparsed_statements"]
    else:
        metadata.pop("synthetic_data_unparsed_statements", None)
    if stats.get("stanc_path"):
        metadata["synthetic_data_stanc"] = stats["stanc_path"]
    if stats.get("stanc_error"):
        metadata["synthetic_data_stanc_error"] = stats["stanc_error"]
    else:
        metadata.pop("synthetic_data_stanc_error", None)
    write_json(path, metadata)


def placeholder_model_dirs(models_root: Path) -> list[Path]:
    dirs: list[Path] = []
    for metadata_path in models_root.glob("*/*/metadata.json"):
        metadata = load_json(metadata_path)
        if metadata.get("data_placeholder") is True:
            dirs.append(metadata_path.parent)
    return sorted(dirs)


def all_model_dirs(models_root: Path) -> list[Path]:
    return sorted(path.parent for path in models_root.glob("*/*/model.stan"))


def failed_model_dirs_from_report(report_path: Path) -> list[Path]:
    report = load_json(report_path)
    dirs: list[Path] = []
    for item in report.get("results", []):
        if item.get("ok"):
            continue
        model = ROOT / str(item.get("model", ""))
        if (model / "model.stan").exists():
            dirs.append(model.resolve())
    return sorted(set(dirs))


def explicit_model_dirs(values: list[str], models_root: Path) -> list[Path]:
    dirs: list[Path] = []
    for value in values:
        path = Path(value).expanduser()
        if not path.is_absolute():
            path = ROOT / path if value.startswith("models/") else models_root / value
        path = path.resolve()
        if not (path / "model.stan").exists():
            raise SystemExit(f"Model directory does not contain model.stan: {path}")
        dirs.append(path)
    return sorted(set(dirs))


def update_external_summary(models_root: Path) -> None:
    summary_path = models_root / "external_import_summary.json"
    if not summary_path.exists():
        return
    summary = load_json(summary_path)
    models_by_group: dict[str, int] = {}
    copied_by_group: dict[str, int] = {}
    synthetic_by_group: dict[str, int] = {}
    placeholders_by_group: dict[str, int] = {}
    methods: dict[str, int] = {}
    summary_groups = {item.get("source_group") for item in summary.get("sources", [])}
    for metadata_path in models_root.glob("*/*/metadata.json"):
        metadata = load_json(metadata_path)
        group = metadata.get("source_group")
        if not group or group not in summary_groups:
            continue
        models_by_group[group] = models_by_group.get(group, 0) + 1
        if metadata.get("synthetic_data_generator"):
            synthetic_by_group[group] = synthetic_by_group.get(group, 0) + 1
            method = metadata.get("synthetic_data_method", "unknown")
            methods[method] = methods.get(method, 0) + 1
        elif metadata.get("data_placeholder") is True:
            placeholders_by_group[group] = placeholders_by_group.get(group, 0) + 1
        else:
            copied_by_group[group] = copied_by_group.get(group, 0) + 1
    for item in summary.get("sources", []):
        group = item.get("source_group")
        item["models"] = models_by_group.get(group, 0)
        item["copied_or_converted_data"] = copied_by_group.get(group, 0)
        item["placeholder_data"] = placeholders_by_group.get(group, 0)
        item["synthetic_data"] = synthetic_by_group.get(group, 0)
        item["remaining_placeholder_data"] = placeholders_by_group.get(group, 0)
    summary["total_imported_model_directories"] = sum(models_by_group.values())
    summary["total_with_copied_or_converted_data"] = sum(copied_by_group.values())
    summary["total_with_placeholder_data"] = sum(placeholders_by_group.values())
    summary["total_with_synthetic_data"] = sum(synthetic_by_group.values())
    summary["synthetic_data_methods"] = methods
    summary["total_remaining_placeholder_data"] = sum(placeholders_by_group.values())
    write_json(summary_path, summary)

    md_path = models_root / "EXTERNAL_IMPORT_SUMMARY.md"
    if md_path.exists():
        methods_text = ", ".join(
            f"`{method}`: {count}" for method, count in sorted(summary.get("synthetic_data_methods", {}).items())
        )
        lines = [
            "# External Stan Model Import Summary",
            "",
            f"- Total imported model directories: {summary.get('total_imported_model_directories')}",
            f"- Imported data files copied or converted: {summary.get('total_with_copied_or_converted_data')}",
            f"- Synthetic data files generated: {summary.get('total_with_synthetic_data', 0)}",
            f"- Synthetic data methods: {methods_text}",
            f"- Remaining empty placeholder data files: {summary.get('total_remaining_placeholder_data', 0)}",
            f"- Data files larger than {summary.get('max_data_bytes')} bytes were replaced by small synthetic data when generated.",
            "",
            "| Source | Directory | Models | Upstream data copied/converted | Synthetic data | Remaining placeholders | Commit |",
            "|---|---|---:|---:|---:|---:|---|",
        ]
        for item in summary.get("sources", []):
            lines.append(
                "| {label} | `models/{directory}` | {models} | {copied} | {synthetic} | {placeholder} | `{commit}` |".format(
                    label=item["source_group_label"],
                    directory=item["source_group"],
                    models=item["models"],
                    copied=item["copied_or_converted_data"],
                    synthetic=item.get("synthetic_data", 0),
                    placeholder=item.get("remaining_placeholder_data", item.get("placeholder_data", 0)),
                    commit=item["upstream_commit"][:12],
                )
            )
        md_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def find_stanc(explicit: str | None) -> Path | None:
    candidates: list[Path] = []
    if explicit:
        candidates.append(Path(explicit).expanduser())
    for env_name in ("STANC", "STANC3"):
        value = Path(str_path).expanduser() if (str_path := os.environ.get(env_name)) else None
        if value is not None:
            candidates.append(value)
    cmdsafestan = os.environ.get("CMDSAFESTAN")
    if cmdsafestan:
        root = Path(cmdsafestan).expanduser()
        candidates.extend([root / "bin" / "stanc", root / "make" / "stanc"])
    candidates.extend(
        [
            Path("/Users/jacski/safe_stan/cmdstan/bin/stanc"),
            Path("/Users/jacski/safe_stan/cmdstan/make/stanc"),
            Path("/Users/jacski/.cmdstan/cmdstan-2.38.0/bin/stanc"),
            Path("/Users/jacski/.cmdstan/cmdstan-2.38.0/make/stanc"),
        ]
    )
    env_stanc = shutil.which("stanc")
    if env_stanc:
        candidates.append(Path(env_stanc))
    for candidate in candidates:
        if candidate and candidate.is_file():
            return candidate.resolve()
    return None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models-root", default=str(DEFAULT_MODELS_ROOT))
    parser.add_argument("--stanc", help="Path to stanc. Defaults to the cmdsafestan/CmdStan checkout if found.")
    parser.add_argument("--all", action="store_true", help="Regenerate data for every model directory.")
    parser.add_argument("--model-dir", action="append", default=[], help="Specific model directory to regenerate; repeatable.")
    parser.add_argument("--from-smoke-report", help="Regenerate failed model directories from a smoke-test JSON report.")
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    models_root = Path(args.models_root).expanduser().resolve()
    stanc = find_stanc(args.stanc)
    targets: list[Path] = []
    if args.all:
        targets.extend(all_model_dirs(models_root))
    if args.from_smoke_report:
        targets.extend(failed_model_dirs_from_report(Path(args.from_smoke_report).expanduser().resolve()))
    if args.model_dir:
        targets.extend(explicit_model_dirs(args.model_dir, models_root))
    if not targets:
        targets = placeholder_model_dirs(models_root)
    targets = sorted(set(targets))
    generated = 0
    unparsed_total = 0
    stanc_total = 0
    fallback_total = 0
    for model_dir in targets:
        payload, stats = generate_for_model(model_dir, stanc)
        unparsed_total += len(stats["unparsed_statements"])
        if stats["method"] == "stanc_debug_generate_data":
            stanc_total += 1
        else:
            fallback_total += 1
        generated += 1
        if args.dry_run:
            continue
        write_json(model_dir / "data.json", payload)
        update_metadata(model_dir, stats)
        append_source_note(model_dir, stats)
    if not args.dry_run:
        update_external_summary(models_root)
    print(f"generated synthetic data for {generated} model directories")
    print(f"stanc-generated datasets: {stanc_total}")
    print(f"fallback parser datasets: {fallback_total}")
    print(f"unparsed data-block statements: {unparsed_total}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
