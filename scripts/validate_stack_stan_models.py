#!/usr/bin/env python3
"""Verify imported Stack files, existing-layout metadata, data keys and stanc.

This does not compile C++, execute models, or validate statistical behavior.
"""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import subprocess

from import_stack_stan_models import GROUP, IMPORT_ROOT, ROOT, RUN_PY, model_slug, sha256, write_json


def check(row, stanc, timeout):
    relative = Path("models") / GROUP / model_slug(row)
    root = ROOT / relative
    errors = []
    code = (root / "model.stan").read_bytes()
    if sha256(code) != row["model_sha256"]:
        errors.append("model checksum mismatch")
    original = root / "model_original.stan"
    if sha256(original.read_bytes() if original.exists() else code) != row["source_sha256"]:
        errors.append("original checksum mismatch")
    metadata = json.loads((root / "metadata.json").read_text())
    if metadata["id"] != root.name or metadata["source_group"] != GROUP:
        errors.append("model identity mismatch")
    if metadata["stan_file"] != "model.stan" or metadata["data_file"] != "data.json":
        errors.append("nonstandard model/data paths")
    for field, expected in [("source_url", row["source_url"]), ("upstream_commit", row["commit"]), ("licenses", row["licenses"])]:
        if metadata[field] != expected:
            errors.append(field + " mismatch")
    data = json.loads((root / "data.json").read_text())
    json.dumps(data, allow_nan=False)
    if not metadata["data_placeholder"] and set(data) != set(row["compiler_info"]["inputs"]):
        errors.append("data keys differ from Stan input declarations")
    if (root / "run.py").read_text() != RUN_PY:
        errors.append("runner differs from shared runner wrapper")
    if row["source_url"] not in (root / "source.md").read_text():
        errors.append("missing provenance link")
    try:
        result = subprocess.run([str(stanc), "--name=stack_import_model", "--warn-pedantic", "--output=/dev/null", str(root / "model.stan")], capture_output=True, text=True, timeout=timeout)
        ok = result.returncode == 0
        diagnostics = result.stderr.replace(str(ROOT) + "/", "")
    except subprocess.TimeoutExpired:
        ok, diagnostics = False, "stanc timeout"
    return {"model": relative.as_posix(), "integrity_errors": errors, "stanc_ok": ok,
            "stanc_diagnostics": diagnostics, "data_status": metadata["data_status"],
            "synthetic_data_method": metadata.get("synthetic_data_method")}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stanc", type=Path, required=True)
    parser.add_argument("--jobs", type=int, default=6)
    parser.add_argument("--timeout", type=float, default=30)
    parser.add_argument("--report", type=Path, default=ROOT / "runs_metadata/the_stack_import_validation.json")
    args = parser.parse_args()
    rows = [json.loads(line) for line in (IMPORT_ROOT / "selection.jsonl").read_text().splitlines()]
    dataset = json.loads((IMPORT_ROOT / "dataset.json").read_text())
    assert sha256((IMPORT_ROOT / "selection.jsonl").read_bytes()) == dataset["selection_sha256"]
    expected = {model_slug(r) for r in rows}
    actual = {p.parent.name for p in (ROOT / "models" / GROUP).glob("*/model.stan")}
    assert actual == expected, "Missing or unexpected model directories"
    with ThreadPoolExecutor(max_workers=max(1, args.jobs)) as pool:
        results = list(pool.map(lambda r: check(r, args.stanc.resolve(), args.timeout), rows))
    summary = {
        "total": len(results), "integrity_failures": sum(bool(r["integrity_errors"]) for r in results),
        "stanc_ok": sum(r["stanc_ok"] for r in results),
        "stanc_warning_free": sum(r["stanc_ok"] and not r["stanc_diagnostics"] for r in results),
        "data_status": dict(Counter(r["data_status"] for r in results)),
        "synthetic_data_methods": dict(Counter(r["synthetic_data_method"] for r in results)),
        "stanc_sha256": sha256(args.stanc.read_bytes()),
        "validation_scope": "Source hashes, metadata/layout, finite JSON and input-key coverage, stanc parsing/type checking/C++ generation. No C++ builds, execution, sampling or SafeStan validation.",
    }
    write_json(args.report, {**summary, "results": results})
    print(json.dumps(summary, indent=2))
    return int(summary["integrity_failures"] > 0 or summary["stanc_ok"] != len(results))


if __name__ == "__main__":
    raise SystemExit(main())
