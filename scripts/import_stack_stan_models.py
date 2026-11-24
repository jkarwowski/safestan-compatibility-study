#!/usr/bin/env python3
"""Import the pinned, screened Stan subset of bigcode/the-stack-dedup.

The selection manifest is checked in under imports/the_stack. Supply the
original Stan Parquet shard (requires pyarrow), or the prior audit directory.
Only models/the_stack is written. Existing model directories are never replaced.
"""
from __future__ import annotations

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import asdict
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import sys

import generate_synthetic_data_for_missing as synthetic
from import_external_stan_models import RUN_PY, slugify, title_from_slug
from modernize_stan_syntax import modernize_text

ROOT = Path(__file__).resolve().parents[1]
IMPORT_ROOT = ROOT / "imports/the_stack"
GROUP = "the_stack"


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True, allow_nan=False) + "\n")


def model_slug(row: dict) -> str:
    prefix = slugify(row["repository"] + "/" + Path(row["repository_path"]).stem, max_len=100)
    return prefix + "-" + row["source_sha256"][:12]


def model_bytes(row: dict, original: bytes) -> bytes:
    if sha256(original) != row["source_sha256"]:
        raise ValueError("Source checksum mismatch: " + row["id"])
    if row["compile_status"] == "original_pass":
        result = original
    elif row["compile_status"] == "modernized_pass":
        text, changes = modernize_text(original.decode("utf-8"))
        result = text.encode("utf-8")
        if asdict(changes) != row["modernization_edits"]:
            raise ValueError("Modernization differs from audited changes: " + row["id"])
    else:
        raise ValueError("Selection contains an uncompiled candidate: " + row["id"])
    if sha256(result) != row["model_sha256"]:
        raise ValueError("Model checksum mismatch: " + row["id"])
    return result


def import_one(row: dict, original: bytes, models_root: Path) -> Path:
    code = model_bytes(row, original)
    slug = model_slug(row)
    dest = models_root / GROUP / slug
    dest.mkdir(parents=True, exist_ok=False)
    (dest / "model.stan").write_bytes(code)
    if original != code:
        (dest / "model_original.stan").write_bytes(original)
    title = title_from_slug(slugify(Path(row["repository_path"]).stem))
    metadata = {
        "id": slug, "title": title, "source_group": GROUP,
        "source_group_label": "The Stack Stan candidates", "difficulty": "unknown",
        "description": f"Imported Stan program from {row['repository']}: {row['repository_path']}.",
        "source_url": row["source_url"], "source_path": row["repository_path"],
        "upstream_repository": "https://github.com/" + row["repository"],
        "upstream_commit": row["commit"], "licenses": row["licenses"],
        "stan_file": "model.stan", "data_file": "data.json", "include_files": [],
        "data_source": "none", "data_status": "no_matched_upstream_data",
        "data_placeholder": True, "data_match": None, "method": "sample",
        "default_run": {"chains": 4, "iter_warmup": 250, "iter_sampling": 250, "seed": 12345},
    }
    write_json(dest / "metadata.json", metadata)
    write_json(dest / "data.json", {})
    (dest / "run.py").write_text(RUN_PY)
    (dest / "run.py").chmod(0o755)
    repairs = ", ".join(f"{key}={value}" for key, value in row["modernization_edits"].items() if value)
    note = f"""# {title}

- Upstream Stan file: [{row['repository_path']}]({row['source_url']})
- Upstream repository: https://github.com/{row['repository']}
- Upstream commit: `{row['commit']}`
- Upstream data: not recovered
- Dataset: [bigcode/the-stack-dedup](https://huggingface.co/datasets/bigcode/the-stack-dedup), Stan subset
- Audit record: `{row['id']}`; [selection and provenance](../../../imports/the_stack/README.md)
- Original source SHA-256: `{row['source_sha256']}`
- Imported model SHA-256: `{row['model_sha256']}`
- Repository license labels recorded by The Stack: {', '.join(row['licenses'])}
- Compiler screen: `{row['compile_status']}`; pedantic-warning-free: {str(row['pedantic_warning_free']).lower()}
- Review flags: {', '.join(row['review_flags']) or 'none recorded'}
"""
    if original != code:
        note += f"- Changes: {repairs}. Original bytes are preserved in `model_original.stan`.\n"
    if row.get("resolved_symlink"):
        link = row["resolved_symlink"]
        note += f"- Upstream path was a symlink to `{link['symlink_target']}`. The Stack stored its [resolved target contents]({link['resolved_target_url']}); the recorded Git blob SHA identifies the link, while the source SHA-256 identifies the preserved contents.\n"
    note += "\nCompiler acceptance is parsing, type checking, and C++ generation only. Synthetic data does not establish runtime or statistical correctness. SafeStan analysis has not been performed for this import.\n"
    (dest / "source.md").write_text(note)
    return dest


def generate_worker(model_dir: Path, stanc: Path | None) -> None:
    payload, stats = synthetic.generate_for_model(model_dir, stanc)
    encoded = json.dumps(payload, indent=2, sort_keys=True, allow_nan=False) + "\n"
    if len(encoded.encode()) > 1_000_000:
        raise ValueError("synthetic data exceeds the corpus 1 MB data limit")
    # Keep per-model metadata portable. The compiler hash is in the run report.
    stats["stanc_path"] = stanc.name if stanc else None
    if stats.get("stanc_error"):
        stats["stanc_error"] = stats["stanc_error"].replace(str(model_dir), ".")
    (model_dir / "data.json").write_text(encoded)
    synthetic.update_metadata(model_dir, stats)
    synthetic.append_source_note(model_dir, stats)


def generate_one(model_dir: Path, stanc: Path | None, expected_inputs: list[str], timeout: float) -> dict:
    command = [sys.executable, str(Path(__file__).resolve()), "--worker-dir", str(model_dir)]
    if stanc:
        command.extend(["--stanc", str(stanc)])
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, start_new_session=True)
    error = None
    try:
        _, stderr = process.communicate(timeout=timeout)
        if process.returncode:
            error = (stderr.strip().splitlines() or ["generator failed"])[-1]
    except subprocess.TimeoutExpired:
        os.killpg(process.pid, signal.SIGKILL)
        process.communicate()
        error = f"synthetic generation exceeded {timeout:g} seconds"
    metadata_path = model_dir / "metadata.json"
    metadata = json.loads(metadata_path.read_text())
    payload = json.loads((model_dir / "data.json").read_text())
    if not error and set(payload) != set(expected_inputs):
        error = "generated keys differ from compiler input declarations"
    if error:
        write_json(model_dir / "data.json", {})
        metadata.update(data_status="synthetic_generation_failed", data_placeholder=True, data_source="none")
        for key in list(metadata):
            if key.startswith("synthetic_data_"):
                metadata.pop(key)
        write_json(metadata_path, metadata)
        note = model_dir / "source.md"
        text = note.read_text().split("## Synthetic Data", 1)[0].rstrip()
        note.write_text(text + "\n\n## Synthetic Data\n\nGeneration was unsuccessful; `data.json` remains an explicitly marked empty placeholder.\n\nReason: " + error.replace(str(model_dir), ".") + "\n")
    return {"model": f"models/{GROUP}/{model_dir.name}", "data_status": metadata["data_status"],
            "method": metadata.get("synthetic_data_method"), "error": error}


def load_sources(rows: list[dict], audit_dir: Path | None, parquet: Path | None) -> dict[str, bytes]:
    if audit_dir:
        return {r["id"]: (audit_dir / "sources" / (r["id"] + ".stan")).read_bytes() for r in rows}
    if not parquet:
        raise ValueError("Provide --parquet or --audit-dir")
    dataset = json.loads((IMPORT_ROOT / "dataset.json").read_text())
    if sha256(parquet.read_bytes()) != dataset["shard_sha256"]:
        raise ValueError("Parquet shard differs from the pinned dataset")
    import pyarrow.parquet as pq
    contents = pq.read_table(parquet, columns=["content"]).column("content").to_pylist()
    return {r["id"]: contents[r["row"]].encode("utf-8") for r in rows}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--audit-dir", type=Path)
    parser.add_argument("--parquet", type=Path)
    parser.add_argument("--models-root", type=Path, default=ROOT / "models")
    parser.add_argument("--stanc", type=Path)
    parser.add_argument("--jobs", type=int, default=4)
    parser.add_argument("--timeout", type=float, default=45)
    parser.add_argument("--worker-dir", type=Path, help=argparse.SUPPRESS)
    parser.add_argument("--skip-data", action="store_true", help="Leave explicitly marked missing-data placeholders.")
    parser.add_argument("--accept-stack-terms", action="store_true", help="Acknowledge imports/the_stack/TERMS_OF_USE.txt and the original source licenses.")
    args = parser.parse_args()
    if args.worker_dir:
        generate_worker(args.worker_dir, args.stanc)
        return 0
    if not args.accept_stack_terms:
        parser.error("Read imports/the_stack/TERMS_OF_USE.txt and pass --accept-stack-terms before importing.")
    rows = [json.loads(line) for line in (IMPORT_ROOT / "selection.jsonl").read_text().splitlines()]
    sources = load_sources(rows, args.audit_dir, args.parquet)
    # Validate everything before writing, including collisions and source drift.
    slugs = [model_slug(r) for r in rows]
    if len(set(slugs)) != len(slugs):
        raise ValueError("Model-directory collision")
    for row, slug in zip(rows, slugs):
        model_bytes(row, sources[row["id"]])
        if (args.models_root / GROUP / slug).exists():
            raise FileExistsError("Refusing to overwrite existing model: " + slug)
    dirs = [import_one(r, sources[r["id"]], args.models_root) for r in rows]
    results = []
    if not args.skip_data:
        stanc = args.stanc.resolve() if args.stanc else synthetic.find_stanc(None)
        with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
            futures = [pool.submit(generate_one, d, stanc, list(r["compiler_info"]["inputs"]), args.timeout) for r, d in zip(rows, dirs)]
            for future in as_completed(futures):
                results.append(future.result())
                if len(results) % 100 == 0:
                    print(f"Generated/attempted data: {len(results)}/{len(rows)}", flush=True)
    report = {"models": len(rows), "source_group": GROUP,
              "synthetic_data": sorted(results, key=lambda x: x["model"])}
    if args.stanc:
        report["stanc_sha256"] = sha256(args.stanc.read_bytes())
    write_json(args.models_root / "the_stack_import_summary.json", report)
    print(f"Imported {len(rows)} model directories; data failures: {sum(bool(r['error']) for r in results)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
