#!/usr/bin/env python3
"""Generate SafeStan translations through the OpenAI Batch API.

This is a small wrapper around ``generate_safestan_with_openai.py``. It renders
the same Responses API payloads, writes a JSONL batch input file, submits it to
``/v1/batches``, optionally waits for completion, and then writes the returned
translations into the usual ``models_safe/<source>/<model>/`` artifact tree.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.request
import uuid
from datetime import datetime, timezone
from pathlib import Path
from string import Template
from typing import Any

import generate_safestan_with_openai as gen


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_BATCH_URL = "https://api.openai.com/v1/batches"
DEFAULT_FILES_URL = "https://api.openai.com/v1/files"
TERMINAL_STATUSES = {"completed", "failed", "expired", "cancelled"}


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def utc_run_id() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8"))


def optional_string(value: str | None) -> str | None:
    if value is None:
        return None
    stripped = value.strip()
    if not stripped or stripped.lower() == "none":
        return None
    return stripped


def request_json(api_key: str, url: str, payload: dict[str, Any]) -> dict[str, Any]:
    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as error:
        body = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"OpenAI API HTTP {error.code}: {body}") from error


def get_json(api_key: str, url: str) -> dict[str, Any]:
    request = urllib.request.Request(url, headers={"Authorization": f"Bearer {api_key}"})
    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as error:
        body = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"OpenAI API HTTP {error.code}: {body}") from error


def get_bytes(api_key: str, url: str) -> bytes:
    request = urllib.request.Request(url, headers={"Authorization": f"Bearer {api_key}"})
    try:
        with urllib.request.urlopen(request, timeout=300) as response:
            return response.read()
    except urllib.error.HTTPError as error:
        body = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"OpenAI API HTTP {error.code}: {body}") from error


def upload_batch_file(api_key: str, files_url: str, path: Path) -> dict[str, Any]:
    boundary = "----safestan-" + uuid.uuid4().hex
    file_bytes = path.read_bytes()
    parts = [
        (
            f"--{boundary}\r\n"
            'Content-Disposition: form-data; name="purpose"\r\n\r\n'
            "batch\r\n"
        ).encode("utf-8"),
        (
            f"--{boundary}\r\n"
            f'Content-Disposition: form-data; name="file"; filename="{path.name}"\r\n'
            "Content-Type: application/jsonl\r\n\r\n"
        ).encode("utf-8"),
        file_bytes,
        f"\r\n--{boundary}--\r\n".encode("utf-8"),
    ]
    body = b"".join(parts)
    request = urllib.request.Request(
        files_url,
        data=body,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": f"multipart/form-data; boundary={boundary}",
            "Content-Length": str(len(body)),
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=300) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as error:
        body_text = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"OpenAI API HTTP {error.code}: {body_text}") from error


def select_candidates(args: argparse.Namespace) -> list[Path]:
    models_root = Path(args.models_root).expanduser().resolve()
    candidates = gen.model_dirs(models_root, args.data_filename)
    filters = list(args.only)
    if args.only_file:
        filters.extend(
            line.strip()
            for line in Path(args.only_file).read_text(encoding="utf-8").splitlines()
            if line.strip() and not line.lstrip().startswith("#")
        )
    if filters:
        candidates = [
            path
            for path in candidates
            if any(str(path).endswith(value) or str(path.relative_to(ROOT)).endswith(value) for value in filters)
        ]
    if args.limit is not None:
        candidates = candidates[: args.limit]
    return candidates


def custom_id_for(index: int, path: Path) -> str:
    rel = str(path.relative_to(ROOT)).replace("/", "__")
    return f"request-{index:04d}-{rel}"


def render_batch(args: argparse.Namespace, run_dir: Path) -> dict[str, Any]:
    template = Template(Path(args.template).expanduser().resolve().read_text(encoding="utf-8"))
    safe_root = Path(args.safe_root).expanduser().resolve()
    service_tier = optional_string(args.service_tier)
    prompt_cache_key = optional_string(args.prompt_cache_key)
    prompt_cache_retention = optional_string(args.prompt_cache_retention)
    candidates = select_candidates(args)
    jsonl_path = run_dir / "batch_input.jsonl"
    requests_dir = run_dir / "requests"
    requests_dir.mkdir(parents=True, exist_ok=True)
    mapping: dict[str, dict[str, Any]] = {}

    with jsonl_path.open("w", encoding="utf-8") as jsonl:
        for index, path in enumerate(candidates, start=1):
            prompt = gen.render_prompt(template, path, args.source_note_chars, args.data_filename)
            payload = gen.response_payload(
                args.model,
                args.reasoning_effort,
                prompt,
                args.max_output_tokens,
                service_tier=service_tier,
                prompt_cache_key=prompt_cache_key,
                prompt_cache_retention=prompt_cache_retention,
            )
            custom_id = custom_id_for(index, path)
            request_obj = {
                "custom_id": custom_id,
                "method": "POST",
                "url": "/v1/responses",
                "body": payload,
            }
            jsonl.write(json.dumps(request_obj, separators=(",", ":")) + "\n")
            request_stem = requests_dir / custom_id
            (request_stem.with_suffix(".prompt.txt")).write_text(prompt, encoding="utf-8")
            write_json(request_stem.with_suffix(".request.json"), payload)
            safe_model_dir = gen.safe_dir_for(safe_root, path)
            mapping[custom_id] = {
                "path": str(path.relative_to(ROOT)),
                "safe_dir": str(safe_model_dir.relative_to(ROOT)),
                "prompt_path": str(request_stem.with_suffix(".prompt.txt").relative_to(ROOT)),
                "request_path": str(request_stem.with_suffix(".request.json").relative_to(ROOT)),
            }

    return {
        "run_id": args.run_id,
        "created_at": utc_now(),
        "model": args.model,
        "reasoning_effort": args.reasoning_effort,
        "data_filename": args.data_filename,
        "service_tier": service_tier,
        "prompt_cache_key": prompt_cache_key,
        "prompt_cache_retention": prompt_cache_retention,
        "safe_root": str(safe_root.relative_to(ROOT)),
        "total": len(candidates),
        "batch_input": str(jsonl_path.relative_to(ROOT)),
        "mapping": mapping,
    }


def submit_batch(args: argparse.Namespace, api_key: str, run_dir: Path, summary: dict[str, Any]) -> dict[str, Any]:
    file_obj = upload_batch_file(api_key, args.files_url, ROOT / summary["batch_input"])
    batch_obj = request_json(
        api_key,
        args.batch_url,
        {
            "input_file_id": file_obj["id"],
            "endpoint": "/v1/responses",
            "completion_window": args.completion_window,
            "metadata": {
                "run_id": args.run_id,
                "description": "SafeStan targeted compile-failure regeneration",
            },
        },
    )
    summary["input_file"] = file_obj
    summary["batch"] = batch_obj
    summary["batch_id"] = batch_obj["id"]
    write_json(run_dir / "summary.json", summary)
    return summary


def poll_batch(args: argparse.Namespace, api_key: str, summary: dict[str, Any], run_dir: Path) -> dict[str, Any]:
    batch_id = args.batch_id or summary.get("batch_id")
    if not batch_id:
        raise SystemExit("No batch id available to poll")
    deadline = time.monotonic() + args.wait_timeout_seconds
    while True:
        batch_obj = get_json(api_key, f"{args.batch_url}/{batch_id}")
        summary["batch"] = batch_obj
        summary["batch_id"] = batch_id
        write_json(run_dir / "summary.json", summary)
        status = batch_obj.get("status")
        counts = batch_obj.get("request_counts") or {}
        print(f"batch {batch_id}: status={status} counts={counts}", flush=True)
        if status in TERMINAL_STATUSES:
            return summary
        if not args.wait:
            return summary
        if time.monotonic() >= deadline:
            raise TimeoutError(f"Timed out waiting for batch {batch_id}")
        time.sleep(args.poll_seconds)


def download_outputs(args: argparse.Namespace, api_key: str, summary: dict[str, Any], run_dir: Path) -> None:
    batch_obj = summary.get("batch") or {}
    for key, filename in (("output_file_id", "batch_output.jsonl"), ("error_file_id", "batch_errors.jsonl")):
        file_id = batch_obj.get(key)
        if not file_id:
            continue
        data = get_bytes(api_key, f"{args.files_url}/{file_id}/content")
        (run_dir / filename).write_bytes(data)
        summary[filename] = str((run_dir / filename).relative_to(ROOT))
    write_json(run_dir / "summary.json", summary)


def process_outputs(summary: dict[str, Any], run_dir: Path) -> dict[str, Any]:
    output_path = run_dir / "batch_output.jsonl"
    if not output_path.exists():
        return {"processed": 0, "errors": 0, "records": []}
    safe_root = ROOT / summary["safe_root"]
    records: list[dict[str, Any]] = []
    mapping = summary["mapping"]
    for line in output_path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        item = json.loads(line)
        custom_id = item["custom_id"]
        mapped = mapping[custom_id]
        model_path = ROOT / mapped["path"]
        safe_model_dir = safe_root / Path(mapped["safe_dir"]).relative_to(summary["safe_root"])
        artifact_dir = gen.artifact_dir_for(safe_model_dir)
        response = (item.get("response") or {}).get("body")
        status_code = (item.get("response") or {}).get("status_code")
        record = {
            "path": mapped["path"],
            "safe_dir": mapped["safe_dir"],
            "started_at": summary["created_at"],
            "completed_at": utc_now(),
            "model": summary["model"],
            "reasoning_effort": summary["reasoning_effort"],
            "data_filename": summary["data_filename"],
            "batch_id": summary.get("batch_id"),
            "batch_request_id": item.get("id"),
            "batch_custom_id": custom_id,
        }
        if summary.get("service_tier"):
            record["service_tier"] = summary["service_tier"]
        if summary.get("prompt_cache_key"):
            record["prompt_cache_key"] = summary["prompt_cache_key"]
        if summary.get("prompt_cache_retention"):
            record["prompt_cache_retention"] = summary["prompt_cache_retention"]
        record["artifacts_dir"] = str(artifact_dir.relative_to(ROOT))

        if status_code != 200 or response is None:
            record["error"] = json.dumps(item.get("error") or item.get("response"), sort_keys=True)
            records.append(record)
            continue

        gen.clear_translation_outputs(safe_model_dir)
        gen.clear_api_artifacts(artifact_dir)
        artifact_dir.mkdir(parents=True, exist_ok=True)
        (artifact_dir / "prompt.txt").write_text((ROOT / mapped["prompt_path"]).read_text(encoding="utf-8"), encoding="utf-8")
        write_json(artifact_dir / "request.json", read_json(ROOT / mapped["request_path"]))
        write_json(artifact_dir / "response.json", response)
        write_json(artifact_dir / "usage.json", response.get("usage", {}))
        try:
            translation = gen.parse_translation(response)
            write_json(artifact_dir / "translation.json", translation)
            write_result = gen.write_translation(safe_model_dir, translation)
            record.update(write_result)
            record["protected_variables"] = translation.get("protected_variables", [])
            record["response_id"] = response.get("id")
            record["usage"] = response.get("usage")
        except Exception as error:  # noqa: BLE001
            record["error"] = str(error)
            (artifact_dir / "error.txt").write_text(str(error), encoding="utf-8")
        gen.save_model_record(artifact_dir, record)
        records.append(record)

    errors = sum(1 for record in records if "error" in record)
    process_summary = {"processed": len(records), "errors": errors, "records": records}
    write_json(run_dir / "process_summary.json", process_summary)
    return process_summary


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models-root", default=str(ROOT / "models"))
    parser.add_argument("--template", default=str(gen.DEFAULT_TEMPLATE))
    parser.add_argument("--safe-root", default=str(gen.DEFAULT_SAFE_ROOT))
    parser.add_argument("--runs-root", default=str(ROOT / "runs_metadata"))
    parser.add_argument("--run-id", default=f"safestan-batch-{utc_run_id()}")
    parser.add_argument("--model", default=gen.DEFAULT_MODEL)
    parser.add_argument("--reasoning-effort", default=gen.DEFAULT_REASONING_EFFORT)
    parser.add_argument("--max-output-tokens", type=int, default=gen.DEFAULT_MAX_OUTPUT_TOKENS)
    parser.add_argument("--service-tier", default=gen.DEFAULT_SERVICE_TIER, choices=["auto", "default", "flex", "priority", "scale", "none"])
    parser.add_argument("--prompt-cache-key", default=gen.DEFAULT_PROMPT_CACHE_KEY)
    parser.add_argument("--prompt-cache-retention", default=gen.DEFAULT_PROMPT_CACHE_RETENTION, choices=["24h", "in-memory", "none"])
    parser.add_argument("--source-note-chars", type=int, default=1600)
    parser.add_argument("--data-filename", default="data.json")
    parser.add_argument("--limit", type=int)
    parser.add_argument("--only", action="append", default=[])
    parser.add_argument("--only-file")
    parser.add_argument("--batch-url", default=DEFAULT_BATCH_URL)
    parser.add_argument("--files-url", default=DEFAULT_FILES_URL)
    parser.add_argument("--completion-window", default="24h")
    parser.add_argument("--batch-id")
    parser.add_argument("--wait", action="store_true")
    parser.add_argument("--poll-seconds", type=int, default=60)
    parser.add_argument("--wait-timeout-seconds", type=int, default=86400)
    parser.add_argument("--no-submit", action="store_true", help="Render batch files but do not upload/submit.")
    parser.add_argument("--process-only", action="store_true", help="Process an existing completed batch from summary.json or --batch-id.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    run_dir = Path(args.runs_root).expanduser().resolve() / args.run_id
    run_dir.mkdir(parents=True, exist_ok=True)
    summary_path = run_dir / "summary.json"
    summary = read_json(summary_path) if summary_path.exists() else None

    if summary is None and not args.process_only:
        summary = render_batch(args, run_dir)
        write_json(summary_path, summary)
        print(f"rendered {summary['total']} requests to {summary['batch_input']}", flush=True)
    elif summary is None:
        raise SystemExit(f"No summary found at {summary_path}")

    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key and not args.no_submit:
        raise SystemExit("OPENAI_API_KEY is not set. Export it in the shell before running this script.")

    if not args.no_submit and not args.process_only and "batch_id" not in summary:
        summary = submit_batch(args, api_key, run_dir, summary)
        print(f"submitted batch {summary['batch_id']}", flush=True)

    if args.wait or args.process_only:
        summary = poll_batch(args, api_key, summary, run_dir)
        if (summary.get("batch") or {}).get("status") == "completed":
            download_outputs(args, api_key, summary, run_dir)
            process_summary = process_outputs(summary, run_dir)
            print(f"processed={process_summary['processed']} errors={process_summary['errors']}", flush=True)
            return 1 if process_summary["errors"] else 0
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
