#!/usr/bin/env python3
"""Generate SafeStan translations for the small model corpus via OpenAI.

The script iterates over model directories containing `model.stan` and
`data.json`, prompts an OpenAI reasoning model with a shared template, and writes
the returned `model_safe.stan`, `data_safe.json`, and `SAFETY_NOTE.md` beside the
original files. For models classified as `major`, stale safe files are removed.
Each API call is also saved under `openai_safestan_runs/<run_id>/` with the full
prompt, request payload, raw response, parsed output, usage, and per-model record.

The API key is read only from `OPENAI_API_KEY`.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime, timezone
from pathlib import Path
from string import Template
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_TEMPLATE = ROOT / "scripts" / "safestan_translation_prompt.md"
DEFAULT_API_URL = "https://api.openai.com/v1/responses"
DEFAULT_MODEL = "gpt-5.5"
DEFAULT_REASONING_EFFORT = "high"
DEFAULT_RUNS_ROOT = ROOT / "openai_safestan_runs"

OUTPUT_SCHEMA: dict[str, Any] = {
    "type": "object",
    "additionalProperties": False,
    "properties": {
        "compatibility": {
            "type": "string",
            "enum": ["as-is", "minor", "major"],
        },
        "safety_note_md": {
            "type": "string",
            "description": "Markdown content for SAFETY_NOTE.md.",
        },
        "model_safe_stan": {
            "type": "string",
            "description": "Full model_safe.stan content, or empty string for major rewrites.",
        },
        "data_safe_json": {
            "type": "string",
            "description": "Valid JSON object text for data_safe.json, or empty string for major rewrites.",
        },
    },
    "required": [
        "compatibility",
        "safety_note_md",
        "model_safe_stan",
        "data_safe_json",
    ],
}


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
    path.write_text(value, encoding="utf-8")


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def utc_run_id() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")


def model_dirs(models_root: Path) -> list[Path]:
    return sorted(
        path.parent
        for path in models_root.glob("*/*/model.stan")
        if (path.parent / "data.json").is_file()
    )


def compact_metadata(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {}
    raw = load_json(path)
    keep = [
        "id",
        "title",
        "source_group",
        "source_group_label",
        "difficulty",
        "description",
        "source_url",
        "translation_note",
        "method",
    ]
    return {key: raw[key] for key in keep if key in raw}


def read_source_note(path: Path, max_chars: int) -> str:
    if not path.exists():
        return ""
    text = path.read_text(encoding="utf-8")
    if len(text) <= max_chars:
        return text
    return text[:max_chars].rstrip() + "\n[truncated]"


def render_prompt(template: Template, model_dir: Path, source_note_chars: int) -> str:
    model_text = (model_dir / "model.stan").read_text(encoding="utf-8")
    data_text = (model_dir / "data.json").read_text(encoding="utf-8")
    metadata = compact_metadata(model_dir / "metadata.json")
    return template.safe_substitute(
        model_dir=str(model_dir.relative_to(ROOT)),
        metadata_json=json.dumps(metadata, indent=2, sort_keys=True),
        source_note=read_source_note(model_dir / "source.md", source_note_chars),
        model_stan=model_text,
        data_json=data_text,
    )


def response_payload(model: str, reasoning_effort: str, prompt: str, max_output_tokens: int) -> dict[str, Any]:
    return {
        "model": model,
        "reasoning": {"effort": reasoning_effort},
        "input": [
            {
                "role": "user",
                "content": prompt,
            }
        ],
        "text": {
            "format": {
                "type": "json_schema",
                "name": "safestan_translation",
                "strict": True,
                "schema": OUTPUT_SCHEMA,
            }
        },
        "max_output_tokens": max_output_tokens,
    }


def extract_output_text(response: dict[str, Any]) -> str:
    if isinstance(response.get("output_text"), str):
        return response["output_text"]
    chunks: list[str] = []
    for item in response.get("output", []):
        if item.get("type") != "message":
            continue
        for content in item.get("content", []):
            if isinstance(content.get("text"), str):
                chunks.append(content["text"])
    return "".join(chunks)


def call_openai(
    *,
    api_key: str,
    api_url: str,
    payload: dict[str, Any],
    timeout: int,
    retries: int,
) -> dict[str, Any]:
    encoded = json.dumps(payload).encode("utf-8")
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    for attempt in range(retries + 1):
        request = urllib.request.Request(api_url, data=encoded, headers=headers, method="POST")
        try:
            with urllib.request.urlopen(request, timeout=timeout) as response:
                return json.loads(response.read().decode("utf-8"))
        except urllib.error.HTTPError as error:
            body = error.read().decode("utf-8", errors="replace")
            retryable = error.code == 429 or 500 <= error.code < 600
            if attempt < retries and retryable:
                time.sleep(min(30, 2**attempt))
                continue
            raise RuntimeError(f"OpenAI API HTTP {error.code}: {body}") from error
        except urllib.error.URLError as error:
            if attempt < retries:
                time.sleep(min(30, 2**attempt))
                continue
            raise RuntimeError(f"OpenAI API request failed: {error}") from error
    raise AssertionError("unreachable")


def artifact_dir_for(run_root: Path, model_dir: Path) -> Path:
    rel = model_dir.relative_to(ROOT)
    return run_root.joinpath(*rel.parts)


def save_model_record(artifact_dir: Path | None, record: dict[str, Any]) -> None:
    if artifact_dir is not None:
        write_json(artifact_dir / "record.json", record)


def artifacts_complete(artifact_dir: Path) -> bool:
    required = ("response.json", "translation.json", "usage.json", "record.json")
    if not all((artifact_dir / filename).is_file() for filename in required):
        return False
    try:
        record = load_json(artifact_dir / "record.json")
    except (OSError, json.JSONDecodeError):
        return False
    return "error" not in record


def normalize_text(text: str) -> str:
    return text.rstrip() + "\n"


def parse_translation(response: dict[str, Any]) -> dict[str, Any]:
    output_text = extract_output_text(response)
    if not output_text:
        raise ValueError("response did not contain output text")
    try:
        parsed = json.loads(output_text)
    except json.JSONDecodeError as error:
        raise ValueError(f"response output was not valid JSON: {error}") from error
    missing = set(OUTPUT_SCHEMA["required"]) - set(parsed)
    if missing:
        raise ValueError(f"response missing required field(s): {', '.join(sorted(missing))}")
    if parsed["compatibility"] not in {"as-is", "minor", "major"}:
        raise ValueError(f"invalid compatibility: {parsed['compatibility']}")
    return parsed


def write_translation(model_dir: Path, translation: dict[str, Any]) -> dict[str, Any]:
    compatibility = translation["compatibility"]
    note = normalize_text(translation["safety_note_md"])
    model_safe = translation["model_safe_stan"].strip()
    data_safe = translation["data_safe_json"].strip()
    note_path = model_dir / "SAFETY_NOTE.md"
    model_safe_path = model_dir / "model_safe.stan"
    data_safe_path = model_dir / "data_safe.json"

    note_path.write_text(note, encoding="utf-8")

    if compatibility == "major":
        for path in (model_safe_path, data_safe_path):
            if path.exists():
                path.unlink()
        return {
            "compatibility": compatibility,
            "wrote_model_safe": False,
            "wrote_data_safe": False,
        }

    if not model_safe:
        raise ValueError("AS-IS/MINOR response did not include model_safe_stan")
    if not data_safe:
        raise ValueError("AS-IS/MINOR response did not include data_safe_json")
    try:
        parsed_data = json.loads(data_safe)
    except json.JSONDecodeError as error:
        raise ValueError(f"data_safe_json is not valid JSON: {error}") from error
    if not isinstance(parsed_data, dict):
        raise ValueError("data_safe_json must be a JSON object")

    model_safe_path.write_text(normalize_text(model_safe), encoding="utf-8")
    write_json(data_safe_path, parsed_data)
    return {
        "compatibility": compatibility,
        "wrote_model_safe": True,
        "wrote_data_safe": True,
    }


def clear_translation_outputs(model_dir: Path) -> None:
    for filename in ("model_safe.stan", "data_safe.json", "SAFETY_NOTE.md"):
        path = model_dir / filename
        if path.exists():
            path.unlink()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models-root", default=str(ROOT / "models"))
    parser.add_argument("--template", default=str(DEFAULT_TEMPLATE))
    parser.add_argument("--output", default=str(ROOT / "openai_safestan_generation.json"))
    parser.add_argument("--runs-root", default=str(DEFAULT_RUNS_ROOT), help="Directory where reproducibility artifacts are saved.")
    parser.add_argument("--run-id", help="Artifact run id. Defaults to current UTC timestamp.")
    parser.add_argument("--no-save-artifacts", action="store_true", help="Disable prompt/request/response artifact saving.")
    parser.add_argument("--rerun-existing-artifacts", action="store_true", help="Call the API even when complete artifacts already exist.")
    parser.add_argument("--api-url", default=DEFAULT_API_URL)
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--reasoning-effort", default=DEFAULT_REASONING_EFFORT)
    parser.add_argument("--max-output-tokens", type=int, default=16000)
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--retries", type=int, default=3)
    parser.add_argument("--sleep-seconds", type=float, default=0.0)
    parser.add_argument("--source-note-chars", type=int, default=1600)
    parser.add_argument("--limit", type=int)
    parser.add_argument("--only", action="append", default=[], help="Process only matching model dir suffix or path; repeatable.")
    parser.add_argument("--dry-run", action="store_true", help="Render prompts and list models without calling the API.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    models_root = Path(args.models_root).expanduser().resolve()
    template_path = Path(args.template).expanduser().resolve()
    template = Template(template_path.read_text(encoding="utf-8"))

    candidates = model_dirs(models_root)
    if args.only:
        filters = tuple(args.only)
        candidates = [
            path
            for path in candidates
            if any(str(path).endswith(value) or str(path.relative_to(ROOT)).endswith(value) for value in filters)
        ]
    if args.limit is not None:
        candidates = candidates[: args.limit]

    if args.dry_run:
        for path in candidates:
            prompt = render_prompt(template, path, args.source_note_chars)
            print(f"{path.relative_to(ROOT)} prompt_chars={len(prompt)}")
        return 0

    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        raise SystemExit("OPENAI_API_KEY is not set. Export it in the shell before running this script.")

    run_id = args.run_id or utc_run_id()
    run_root: Path | None = None
    if not args.no_save_artifacts:
        run_root = Path(args.runs_root).expanduser().resolve() / run_id
        run_root.mkdir(parents=True, exist_ok=True)

    results: list[dict[str, Any]] = []
    failures = 0
    for index, path in enumerate(candidates, start=1):
        rel = str(path.relative_to(ROOT))
        print(f"[{index}/{len(candidates)}] {rel}", flush=True)
        artifact_dir = artifact_dir_for(run_root, path) if run_root is not None else None
        record: dict[str, Any] = {
            "path": rel,
            "started_at": utc_now(),
            "model": args.model,
            "reasoning_effort": args.reasoning_effort,
        }
        if artifact_dir is not None:
            record["artifacts_dir"] = str(artifact_dir.relative_to(ROOT))
        try:
            if (
                artifact_dir is not None
                and artifacts_complete(artifact_dir)
                and not args.rerun_existing_artifacts
            ):
                previous_record = load_json(artifact_dir / "record.json")
                translation = load_json(artifact_dir / "translation.json")
                write_result = write_translation(path, translation)
                record.update(write_result)
                record["response_id"] = previous_record.get("response_id")
                record["usage"] = load_json(artifact_dir / "usage.json")
                record["skipped_existing_artifacts"] = True
                record["completed_at"] = utc_now()
                print(f"  -> {record['compatibility']} (skipped existing artifacts)", flush=True)
                results.append(record)
                if args.sleep_seconds and index < len(candidates):
                    time.sleep(args.sleep_seconds)
                continue

            clear_translation_outputs(path)
            prompt = render_prompt(template, path, args.source_note_chars)
            payload = response_payload(args.model, args.reasoning_effort, prompt, args.max_output_tokens)
            if artifact_dir is not None:
                write_text(artifact_dir / "prompt.txt", prompt)
                write_json(artifact_dir / "request.json", payload)
            response = call_openai(
                api_key=api_key,
                api_url=args.api_url,
                payload=payload,
                timeout=args.timeout,
                retries=args.retries,
            )
            if artifact_dir is not None:
                write_json(artifact_dir / "response.json", response)
                write_json(artifact_dir / "usage.json", response.get("usage", {}))
            translation = parse_translation(response)
            if artifact_dir is not None:
                write_json(artifact_dir / "translation.json", translation)
            write_result = write_translation(path, translation)
            record.update(write_result)
            record["response_id"] = response.get("id")
            record["usage"] = response.get("usage")
            record["completed_at"] = utc_now()
            print(f"  -> {record['compatibility']}", flush=True)
        except Exception as error:  # noqa: BLE001 - batch runner records and continues.
            failures += 1
            record["error"] = str(error)
            record["completed_at"] = utc_now()
            if artifact_dir is not None:
                write_text(artifact_dir / "error.txt", str(error))
            print(f"  !! {error}", file=sys.stderr, flush=True)
        save_model_record(artifact_dir, record)
        results.append(record)
        if args.sleep_seconds and index < len(candidates):
            time.sleep(args.sleep_seconds)

    summary = {
        "generated_at": utc_now(),
        "models_root": str(models_root),
        "model": args.model,
        "reasoning_effort": args.reasoning_effort,
        "run_id": run_id,
        "artifacts_root": str(run_root) if run_root is not None else None,
        "total": len(results),
        "failures": failures,
        "results": results,
    }
    write_json(Path(args.output).expanduser().resolve(), summary)
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
