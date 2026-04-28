#!/usr/bin/env python3
"""Import external Stan model repositories into this corpus layout.

The script expects shallow clones of the upstream repositories under
`/tmp/stan-collection-sources` by default and writes model directories under
`models/`.  Each imported directory follows the existing corpus shape:

    model.stan
    data.json
    metadata.json
    source.md
    run.py

Posteriordb is imported at posterior-instance granularity because that is where
the repository records model/data pairings.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import textwrap
import zipfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE_ROOT = Path("/tmp/stan-collection-sources")
DEFAULT_MODELS_ROOT = ROOT / "models"
MAX_DATA_BYTES = 1_000_000

RUN_PY = """#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))

from scripts.run_cmdstan_model import main

if __name__ == "__main__":
    raise SystemExit(main(["--model-dir", str(Path(__file__).resolve().parent), *sys.argv[1:]]))
"""

PROGRAM_BLOCK_RE = re.compile(
    r"^\s*(data|transformed\s+data|parameters|transformed\s+parameters|model|generated\s+quantities)\s*\{",
    re.MULTILINE,
)
INCLUDE_RE = re.compile(r'^\s*#\s*include\s+["<]([^">]+)[">]\s*$', re.MULTILINE)


@dataclass(frozen=True)
class SourceSpec:
    repo_dir: str
    target_dir: str
    label: str
    repo_url: str


SOURCES = [
    SourceSpec(
        repo_dir="stancon_talks",
        target_dir="stancon_talks",
        label="StanCon talks",
        repo_url="https://github.com/stan-dev/stancon_talks",
    ),
    SourceSpec(
        repo_dir="BDA_R_demos",
        target_dir="bda_r_demos",
        label="BDA R demos",
        repo_url="https://github.com/avehtari/BDA_R_demos",
    ),
    SourceSpec(
        repo_dir="knitr_case_studies",
        target_dir="betanalpha_knitr_case_studies",
        label="Betancourt knitr case studies",
        repo_url="https://github.com/betanalpha/knitr_case_studies",
    ),
    SourceSpec(
        repo_dir="example-models",
        target_dir="example_models",
        label="Stan example models",
        repo_url="https://github.com/stan-dev/example-models",
    ),
]

POSTERIORDB = SourceSpec(
    repo_dir="posteriordb",
    target_dir="posteriordb",
    label="PosteriorDB curated models",
    repo_url="https://github.com/stan-dev/posteriordb",
)


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2, sort_keys=True)
        handle.write("\n")


def write_text(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value.rstrip() + "\n", encoding="utf-8")


def git_commit(repo: Path) -> str:
    return subprocess.check_output(["git", "-C", str(repo), "rev-parse", "HEAD"], text=True).strip()


def slugify(value: str, max_len: int = 120) -> str:
    value = value.replace(os.sep, "-").replace("/", "-")
    value = re.sub(r"[^A-Za-z0-9]+", "-", value).strip("-").lower()
    value = re.sub(r"-+", "-", value)
    if not value:
        value = "model"
    if len(value) <= max_len:
        return value
    digest = hashlib.sha1(value.encode("utf-8")).hexdigest()[:10]
    return f"{value[: max_len - 11].rstrip('-')}-{digest}"


def unique_slug(base: str, used: set[str]) -> str:
    slug = slugify(base)
    candidate = slug
    index = 2
    while candidate in used:
        suffix = f"-{index}"
        candidate = f"{slug[: 120 - len(suffix)].rstrip('-')}{suffix}"
        index += 1
    used.add(candidate)
    return candidate


def title_from_slug(slug: str) -> str:
    return " ".join(part.upper() if part in {"gp", "irt", "ode", "glm", "glmm"} else part.capitalize() for part in slug.split("-"))


def github_blob_url(spec: SourceSpec, commit: str, rel_path: str) -> str:
    return f"{spec.repo_url}/blob/{commit}/{rel_path}"


def is_standalone_stan(path: Path) -> bool:
    if path.stat().st_size == 0:
        return False
    text = path.read_text(encoding="utf-8", errors="replace")
    return bool(PROGRAM_BLOCK_RE.search(text))


def read_stan_with_includes(path: Path, seen: set[Path] | None = None) -> tuple[str, list[Path]]:
    seen = set() if seen is None else seen
    path = path.resolve()
    if path in seen:
        raise ValueError(f"cyclic Stan include detected at {path}")
    seen.add(path)
    includes: list[Path] = []
    text = path.read_text(encoding="utf-8", errors="replace")

    def replace(match: re.Match[str]) -> str:
        include_name = match.group(1).strip()
        include_path = (path.parent / include_name).resolve()
        if not include_path.exists():
            return match.group(0)
        include_text, nested = read_stan_with_includes(include_path, seen)
        includes.append(include_path)
        includes.extend(nested)
        rel = include_path.relative_to(path.parent)
        return f"// Begin expanded include: {rel}\n{include_text.rstrip()}\n// End expanded include: {rel}"

    return INCLUDE_RE.sub(replace, text), includes


def data_files_under(path: Path) -> list[Path]:
    if not path.exists():
        return []
    return sorted(
        p
        for p in path.rglob("*")
        if p.is_file()
        and (
            p.name.endswith(".data.json")
            or p.name.endswith(".data.R")
            or p.name == "data.json"
        )
    )


def direct_data_candidates(stan_path: Path) -> list[Path]:
    base = stan_path.with_suffix("")
    return [
        Path(f"{base}.data.json"),
        Path(f"{base}.data.R"),
        Path(f"{base}.json"),
        stan_path.parent / "data.json",
    ]


def normalized_data_stem(path: Path) -> str:
    name = path.name.lower()
    for suffix in (".data.json", ".data.r", ".json"):
        if name.endswith(suffix):
            name = name[: -len(suffix)]
            break
    return slugify(name)


def choose_nearby_data(source_root: Path, stan_path: Path) -> tuple[Path | None, str]:
    for candidate in direct_data_candidates(stan_path):
        if candidate.exists():
            return candidate, "direct"

    relative = stan_path.relative_to(source_root)
    if relative.parts:
        top = source_root / relative.parts[0]
        data_files = data_files_under(top)
        exact = [item for item in data_files if normalized_data_stem(item) == slugify(stan_path.stem)]
        if len(exact) == 1:
            return exact[0], "top-level exact stem"
        if len(data_files) == 1:
            return data_files[0], "top-level single data file"

    for ancestor in (stan_path.parent, *stan_path.parents):
        if ancestor == source_root.parent or source_root not in (ancestor, *ancestor.parents):
            break
        data_files = data_files_under(ancestor)
        exact = [item for item in data_files if normalized_data_stem(item) == slugify(stan_path.stem)]
        if len(exact) == 1:
            return exact[0], "ancestor exact stem"
        if len(data_files) == 1:
            return data_files[0], "ancestor single data file"

    return None, "no matched upstream data"


def placeholder_data(reason: str) -> dict[str, Any]:
    return {"data_status": reason, "placeholder": True}


def copy_json_data(source: Path, dest: Path) -> dict[str, Any]:
    size = source.stat().st_size
    if size > MAX_DATA_BYTES:
        write_json(dest, {})
        return placeholder_data(f"skipped_large_json:{size}")
    try:
        payload = load_json(source)
    except json.JSONDecodeError as error:
        write_json(dest, {})
        return placeholder_data(f"invalid_json:{error}")
    write_json(dest, payload)
    return {"data_status": "copied_json", "placeholder": False, "upstream_data_bytes": size}


def convert_rdump_data(source: Path, dest: Path) -> dict[str, Any]:
    dest.parent.mkdir(parents=True, exist_ok=True)
    script = r"""
args <- commandArgs(trailingOnly = TRUE)
input <- args[[1]]
output <- args[[2]]
env <- new.env(parent = baseenv())
source(input, local = env)
values <- as.list(env, all.names = FALSE)
values <- values[!vapply(values, is.function, logical(1))]
jsonlite::write_json(values, output, auto_unbox = TRUE, digits = NA, null = "null", pretty = TRUE)
"""
    try:
        subprocess.run(
            ["Rscript", "-e", script, str(source), str(dest)],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
    except (FileNotFoundError, subprocess.CalledProcessError) as error:
        write_json(dest, {})
        return placeholder_data(f"rdump_conversion_failed:{error}")
    size = dest.stat().st_size
    if size > MAX_DATA_BYTES:
        write_json(dest, {})
        return placeholder_data(f"skipped_large_converted_rdump:{size}")
    try:
        load_json(dest)
    except json.JSONDecodeError as error:
        write_json(dest, {})
        return placeholder_data(f"converted_rdump_invalid_json:{error}")
    return {"data_status": "converted_rdump", "placeholder": False, "upstream_data_bytes": source.stat().st_size}


def write_data_file(data_source: Path | None, dest: Path) -> dict[str, Any]:
    if data_source is None:
        write_json(dest, {})
        return placeholder_data("no_matched_upstream_data")
    if data_source.name.endswith(".data.R"):
        result = convert_rdump_data(data_source, dest)
    else:
        result = copy_json_data(data_source, dest)
    result["upstream_data_path"] = str(data_source)
    return result


def write_run_py(dest_dir: Path) -> None:
    run_path = dest_dir / "run.py"
    write_text(run_path, RUN_PY)
    run_path.chmod(0o755)


def write_source_note(
    *,
    dest_dir: Path,
    title: str,
    spec: SourceSpec,
    commit: str,
    stan_rel_path: str,
    stan_url: str,
    data_result: dict[str, Any],
    import_note: str,
    include_paths: list[str] | None = None,
) -> None:
    includes = ""
    if include_paths:
        includes = "\n- Expanded Stan includes: " + ", ".join(f"`{item}`" for item in include_paths)
    upstream_data = data_result.get("upstream_data_rel_path") or data_result.get("upstream_data_path") or "none"
    source = f"""# {title}

- Upstream Stan file: [{stan_rel_path}]({stan_url})
- Upstream data: {upstream_data}
- Data status: {data_result.get("data_status")}
- Source group: {spec.label}
- Upstream repository: {spec.repo_url}
- Upstream commit: `{commit}`{includes}
- Import note: {import_note}
"""
    write_text(dest_dir / "source.md", source)


def write_model_dir(
    *,
    dest_dir: Path,
    model_text: str,
    metadata: dict[str, Any],
    source_note_args: dict[str, Any],
    data_result: dict[str, Any],
) -> None:
    dest_dir.mkdir(parents=True, exist_ok=True)
    write_text(dest_dir / "model.stan", model_text)
    write_json(dest_dir / "metadata.json", metadata)
    write_source_note(dest_dir=dest_dir, data_result=data_result, **source_note_args)
    write_run_py(dest_dir)


def import_stan_files(spec: SourceSpec, source_root: Path, models_root: Path) -> dict[str, Any]:
    repo = source_root / spec.repo_dir
    commit = git_commit(repo)
    target_root = models_root / spec.target_dir
    if target_root.exists():
        shutil.rmtree(target_root)
    target_root.mkdir(parents=True, exist_ok=True)

    used: set[str] = set()
    stats: dict[str, Any] = {
        "source_group": spec.target_dir,
        "source_group_label": spec.label,
        "upstream_repository": spec.repo_url,
        "upstream_commit": commit,
        "models": 0,
        "copied_or_converted_data": 0,
        "placeholder_data": 0,
        "skipped_support_files": 0,
    }

    for stan_path in sorted(repo.rglob("*.stan")):
        if not is_standalone_stan(stan_path):
            stats["skipped_support_files"] += 1
            continue
        rel_path = stan_path.relative_to(repo).as_posix()
        slug = unique_slug(Path(rel_path).with_suffix("").as_posix(), used)
        dest_dir = target_root / slug
        title = title_from_slug(slug)
        data_source, data_match = choose_nearby_data(repo, stan_path)
        data_result = write_data_file(data_source, dest_dir / "data.json")
        if data_source is not None:
            data_result["upstream_data_rel_path"] = data_source.relative_to(repo).as_posix()
            data_result["data_match"] = data_match
        model_text, includes = read_stan_with_includes(stan_path)
        include_rel_paths = sorted({item.relative_to(repo).as_posix() for item in includes})
        stan_url = github_blob_url(spec, commit, rel_path)
        data_status = data_result["data_status"]
        if data_result["placeholder"]:
            stats["placeholder_data"] += 1
        else:
            stats["copied_or_converted_data"] += 1
        stats["models"] += 1
        metadata = {
            "id": slug,
            "title": title,
            "source_group": spec.target_dir,
            "source_group_label": spec.label,
            "difficulty": "unknown",
            "description": f"Imported Stan program from {spec.label}: {rel_path}.",
            "source_url": stan_url,
            "source_path": rel_path,
            "upstream_repository": spec.repo_url,
            "upstream_commit": commit,
            "stan_file": "model.stan",
            "data_file": "data.json",
            "data_source": data_result.get("upstream_data_rel_path", "empty JSON object"),
            "data_status": data_status,
            "data_placeholder": data_result["placeholder"],
            "data_match": data_result.get("data_match"),
            "include_files": include_rel_paths,
            "method": "sample",
            "default_run": {
                "chains": 4,
                "iter_warmup": 250,
                "iter_sampling": 250,
                "seed": 12345,
            },
        }
        if "upstream_data_bytes" in data_result:
            metadata["upstream_data_bytes"] = data_result["upstream_data_bytes"]
        source_note_args = {
            "title": title,
            "spec": spec,
            "commit": commit,
            "stan_rel_path": rel_path,
            "stan_url": stan_url,
            "import_note": "Copied into the repository's standard model-directory layout.",
            "include_paths": include_rel_paths,
        }
        write_model_dir(
            dest_dir=dest_dir,
            model_text=model_text,
            metadata=metadata,
            source_note_args=source_note_args,
            data_result=data_result,
        )

    return stats


def posteriordb_data_file(database_root: Path, data_name: str) -> tuple[Path | None, int | None]:
    info_path = database_root / "data" / "info" / f"{data_name}.info.json"
    if not info_path.exists():
        return None, None
    info = load_json(info_path)
    data_file = info.get("data_file")
    if not data_file:
        return None, None
    data_path = database_root / data_file
    zip_path = Path(f"{data_path}.zip")
    if data_path.exists():
        return data_path, data_path.stat().st_size
    if zip_path.exists():
        with zipfile.ZipFile(zip_path) as archive:
            members = [member for member in archive.infolist() if not member.is_dir()]
            if not members:
                return None, None
            return zip_path, members[0].file_size
    return None, None


def write_posteriordb_data(source: Path | None, uncompressed_size: int | None, dest: Path) -> dict[str, Any]:
    if source is None:
        write_json(dest, {})
        return placeholder_data("no_posteriordb_data_file")
    if uncompressed_size is not None and uncompressed_size > MAX_DATA_BYTES:
        write_json(dest, {})
        result = placeholder_data(f"skipped_large_posteriordb_json:{uncompressed_size}")
        result["upstream_data_bytes"] = uncompressed_size
        result["upstream_data_path"] = str(source)
        return result
    if source.suffix == ".zip":
        try:
            with zipfile.ZipFile(source) as archive:
                members = [member for member in archive.infolist() if not member.is_dir()]
                if not members:
                    write_json(dest, {})
                    return placeholder_data("empty_posteriordb_zip")
                with archive.open(members[0]) as handle:
                    payload = json.load(handle)
        except (zipfile.BadZipFile, json.JSONDecodeError) as error:
            write_json(dest, {})
            return placeholder_data(f"invalid_posteriordb_zip_json:{error}")
        write_json(dest, payload)
        return {
            "data_status": "extracted_posteriordb_zip_json",
            "placeholder": False,
            "upstream_data_bytes": uncompressed_size,
            "upstream_data_path": str(source),
        }
    return copy_json_data(source, dest)


def import_posteriordb(source_root: Path, models_root: Path) -> dict[str, Any]:
    spec = POSTERIORDB
    repo = source_root / spec.repo_dir
    database_root = repo / "posterior_database"
    commit = git_commit(repo)
    target_root = models_root / spec.target_dir
    if target_root.exists():
        shutil.rmtree(target_root)
    target_root.mkdir(parents=True, exist_ok=True)

    stats: dict[str, Any] = {
        "source_group": spec.target_dir,
        "source_group_label": spec.label,
        "upstream_repository": spec.repo_url,
        "upstream_commit": commit,
        "models": 0,
        "copied_or_converted_data": 0,
        "placeholder_data": 0,
        "skipped_support_files": 0,
        "posteriordb_granularity": "posterior instances",
    }

    used: set[str] = set()
    for posterior_path in sorted((database_root / "posteriors").glob("*.json")):
        posterior = load_json(posterior_path)
        posterior_name = posterior["name"]
        model_name = posterior["model_name"]
        data_name = posterior["data_name"]
        model_rel_path = f"posterior_database/models/stan/{model_name}.stan"
        stan_path = repo / model_rel_path
        if not stan_path.exists():
            continue
        slug = unique_slug(posterior_name, used)
        dest_dir = target_root / slug
        model_info_path = database_root / "models" / "info" / f"{model_name}.info.json"
        data_info_path = database_root / "data" / "info" / f"{data_name}.info.json"
        model_info = load_json(model_info_path) if model_info_path.exists() else {}
        data_info = load_json(data_info_path) if data_info_path.exists() else {}
        data_source, uncompressed_size = posteriordb_data_file(database_root, data_name)
        data_result = write_posteriordb_data(data_source, uncompressed_size, dest_dir / "data.json")
        if data_source is not None:
            data_result["upstream_data_rel_path"] = data_source.relative_to(repo).as_posix()
        if data_result["placeholder"]:
            stats["placeholder_data"] += 1
        else:
            stats["copied_or_converted_data"] += 1
        stats["models"] += 1

        title = model_info.get("title") or title_from_slug(slug)
        model_text, includes = read_stan_with_includes(stan_path)
        stan_url = github_blob_url(spec, commit, model_rel_path)
        posterior_rel_path = posterior_path.relative_to(repo).as_posix()
        metadata = {
            "id": slug,
            "title": title,
            "source_group": spec.target_dir,
            "source_group_label": spec.label,
            "difficulty": "unknown",
            "description": model_info.get("description") or f"PosteriorDB posterior {posterior_name}.",
            "source_url": stan_url,
            "source_path": model_rel_path,
            "upstream_repository": spec.repo_url,
            "upstream_commit": commit,
            "posterior_name": posterior_name,
            "posterior_info_path": posterior_rel_path,
            "posteriordb_model_name": model_name,
            "posteriordb_data_name": data_name,
            "posteriordb_data_title": data_info.get("title"),
            "stan_file": "model.stan",
            "data_file": "data.json",
            "data_source": data_result.get("upstream_data_rel_path", "empty JSON object"),
            "data_status": data_result["data_status"],
            "data_placeholder": data_result["placeholder"],
            "include_files": [item.relative_to(repo).as_posix() for item in includes],
            "method": "sample",
            "default_run": {
                "chains": 4,
                "iter_warmup": 250,
                "iter_sampling": 250,
                "seed": 12345,
            },
        }
        if "upstream_data_bytes" in data_result:
            metadata["upstream_data_bytes"] = data_result["upstream_data_bytes"]
        source_note_args = {
            "title": title,
            "spec": spec,
            "commit": commit,
            "stan_rel_path": model_rel_path,
            "stan_url": stan_url,
            "import_note": f"Imported from PosteriorDB posterior `{posterior_name}` using data `{data_name}`.",
            "include_paths": [],
        }
        write_model_dir(
            dest_dir=dest_dir,
            model_text=model_text,
            metadata=metadata,
            source_note_args=source_note_args,
            data_result=data_result,
        )

    return stats


def write_summary(models_root: Path, summary: list[dict[str, Any]]) -> None:
    total = sum(item["models"] for item in summary)
    placeholder_total = sum(item["placeholder_data"] for item in summary)
    copied_total = sum(item["copied_or_converted_data"] for item in summary)
    write_json(
        models_root / "external_import_summary.json",
        {
            "total_imported_model_directories": total,
            "total_with_copied_or_converted_data": copied_total,
            "total_with_placeholder_data": placeholder_total,
            "max_data_bytes": MAX_DATA_BYTES,
            "sources": summary,
        },
    )
    lines = [
        "# External Stan Model Import Summary",
        "",
        f"- Total imported model directories: {total}",
        f"- Imported data files copied or converted: {copied_total}",
        f"- Empty placeholder data files: {placeholder_total}",
        f"- Data files larger than {MAX_DATA_BYTES} bytes were left as empty placeholders and marked in metadata.",
        "",
        "| Source | Directory | Models | Data copied/converted | Placeholder data | Commit |",
        "|---|---|---:|---:|---:|---|",
    ]
    for item in summary:
        lines.append(
            "| {label} | `models/{directory}` | {models} | {copied} | {placeholder} | `{commit}` |".format(
                label=item["source_group_label"],
                directory=item["source_group"],
                models=item["models"],
                copied=item["copied_or_converted_data"],
                placeholder=item["placeholder_data"],
                commit=item["upstream_commit"][:12],
            )
        )
    write_text(models_root / "EXTERNAL_IMPORT_SUMMARY.md", "\n".join(lines))


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", default=str(DEFAULT_SOURCE_ROOT))
    parser.add_argument("--models-root", default=str(DEFAULT_MODELS_ROOT))
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    source_root = Path(args.source_root).expanduser().resolve()
    models_root = Path(args.models_root).expanduser().resolve()
    missing = [spec.repo_dir for spec in [*SOURCES, POSTERIORDB] if not (source_root / spec.repo_dir).is_dir()]
    if missing:
        raise SystemExit(f"Missing upstream clone(s) under {source_root}: {', '.join(missing)}")

    summary: list[dict[str, Any]] = []
    summary.append(import_posteriordb(source_root, models_root))
    for spec in SOURCES:
        summary.append(import_stan_files(spec, source_root, models_root))
    write_summary(models_root, summary)
    print(textwrap.dedent(
        f"""
        Imported {sum(item['models'] for item in summary)} model directories.
        Wrote {models_root / 'EXTERNAL_IMPORT_SUMMARY.md'}.
        """
    ).strip())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
