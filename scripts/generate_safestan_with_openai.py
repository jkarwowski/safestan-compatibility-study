#!/usr/bin/env python3
"""Generate SafeStan translations for the model corpus via OpenAI.

The script iterates over model directories containing `model.stan` and
`data.json`, prompts an OpenAI reasoning model with a shared template, and writes
the returned `model_safe.stan`, `data_safe.json`, and `SAFETY_NOTE.md` into a
mirrored `models_safe/<source>/<model>/` tree. Each API call is saved beside the
SafeStan output under `models_safe/<source>/<model>/api/` with the full prompt,
request payload, raw response, parsed output, usage, and per-model record.

The API key is read only from `OPENAI_API_KEY`.
"""

from __future__ import annotations

import argparse
import concurrent.futures
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
DEFAULT_SAFE_ROOT = ROOT / "models_safe"
DEFAULT_SERVICE_TIER = "flex"
DEFAULT_PROMPT_CACHE_KEY = "safestan-translation-v1"
DEFAULT_PROMPT_CACHE_RETENTION = "24h"
DEFAULT_MAX_OUTPUT_TOKENS = 64000
DEFAULT_TIMEOUT = 900
DEFAULT_WORKERS = 4

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
        "protected_variables": {
            "type": "array",
            "items": {"type": "string"},
            "description": "Top-level data variables to pass to --sstan-protect.",
        },
    },
    "required": [
        "compatibility",
        "safety_note_md",
        "model_safe_stan",
        "data_safe_json",
        "protected_variables",
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


def model_dirs(models_root: Path, data_filename: str = "data.json") -> list[Path]:
    return sorted(
        path.parent
        for path in models_root.glob("*/*/model.stan")
        if (path.parent / data_filename).is_file()
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


def render_prompt(
    template: Template,
    model_dir: Path,
    source_note_chars: int,
    data_filename: str = "data.json",
) -> str:
    model_text = (model_dir / "model.stan").read_text(encoding="utf-8")
    data_text = (model_dir / data_filename).read_text(encoding="utf-8")
    metadata = compact_metadata(model_dir / "metadata.json")
    return template.safe_substitute(
        model_dir=str(model_dir.relative_to(ROOT)),
        metadata_json=json.dumps(metadata, indent=2, sort_keys=True),
        source_note=read_source_note(model_dir / "source.md", source_note_chars),
        model_stan=model_text,
        data_filename=data_filename,
        data_json=data_text,
    )


def response_payload(
    model: str,
    reasoning_effort: str,
    prompt: str,
    max_output_tokens: int,
    *,
    service_tier: str | None,
    prompt_cache_key: str | None,
    prompt_cache_retention: str | None,
) -> dict[str, Any]:
    payload: dict[str, Any] = {
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
    if service_tier:
        payload["service_tier"] = service_tier
    if prompt_cache_key:
        payload["prompt_cache_key"] = prompt_cache_key
    if prompt_cache_retention:
        payload["prompt_cache_retention"] = prompt_cache_retention
    return payload


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


def safe_dir_for(safe_root: Path, model_dir: Path) -> Path:
    rel = model_dir.relative_to(ROOT)
    if rel.parts and rel.parts[0] == "models":
        rel = Path(*rel.parts[1:])
    return safe_root.joinpath(*rel.parts)


def artifact_dir_for(safe_model_dir: Path) -> Path:
    return safe_model_dir / "api"


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


def write_translation(output_dir: Path, translation: dict[str, Any]) -> dict[str, Any]:
    output_dir.mkdir(parents=True, exist_ok=True)
    compatibility = translation["compatibility"]
    note = normalize_text(translation["safety_note_md"])
    model_safe = translation["model_safe_stan"].strip()
    data_safe = translation["data_safe_json"].strip()
    note_path = output_dir / "SAFETY_NOTE.md"
    model_safe_path = output_dir / "model_safe.stan"
    data_safe_path = output_dir / "data_safe.json"

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


def clear_api_artifacts(artifact_dir: Path) -> None:
    for filename in ("prompt.txt", "request.json", "response.json", "translation.json", "usage.json", "record.json", "error.txt"):
        path = artifact_dir / filename
        if path.exists():
            path.unlink()


def optional_string(value: str | None) -> str | None:
    if value is None:
        return None
    stripped = value.strip()
    if not stripped or stripped.lower() == "none":
        return None
    return stripped


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models-root", default=str(ROOT / "models"))
    parser.add_argument("--template", default=str(DEFAULT_TEMPLATE))
    parser.add_argument("--output", default=str(ROOT / "openai_safestan_generation.json"))
    parser.add_argument("--safe-root", default=str(DEFAULT_SAFE_ROOT), help="Mirrored output directory for SafeStan translations and API artifacts.")
    parser.add_argument("--runs-root", help=argparse.SUPPRESS)
    parser.add_argument("--run-id", help="Artifact run id. Defaults to current UTC timestamp.")
    parser.add_argument("--no-save-artifacts", action="store_true", help="Disable prompt/request/response artifact saving.")
    parser.add_argument("--rerun-existing-artifacts", action="store_true", help="Call the API even when complete artifacts already exist.")
    parser.add_argument("--api-url", default=DEFAULT_API_URL)
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--reasoning-effort", default=DEFAULT_REASONING_EFFORT)
    parser.add_argument("--max-output-tokens", type=int, default=DEFAULT_MAX_OUTPUT_TOKENS)
    parser.add_argument(
        "--service-tier",
        default=DEFAULT_SERVICE_TIER,
        choices=["auto", "default", "flex", "priority", "scale", "none"],
        help="Responses API service tier. Use 'none' to omit the field.",
    )
    parser.add_argument(
        "--prompt-cache-key",
        default=DEFAULT_PROMPT_CACHE_KEY,
        help="Stable prompt cache routing key. Use 'none' to omit the field.",
    )
    parser.add_argument(
        "--prompt-cache-retention",
        default=DEFAULT_PROMPT_CACHE_RETENTION,
        choices=["24h", "in-memory", "none"],
        help="Prompt cache retention policy. Use 'none' to omit the field.",
    )
    parser.add_argument("--timeout", type=int, default=DEFAULT_TIMEOUT)
    parser.add_argument("--retries", type=int, default=3)
    parser.add_argument("--sleep-seconds", type=float, default=0.0)
    parser.add_argument("--workers", type=int, default=DEFAULT_WORKERS, help="Parallel API worker threads.")
    parser.add_argument("--source-note-chars", type=int, default=1600)
    parser.add_argument(
        "--data-filename",
        default="data.json",
        help="Data file name to include in prompts, relative to each model directory.",
    )
    parser.add_argument("--limit", type=int)
    parser.add_argument("--only", action="append", default=[], help="Process only matching model dir suffix or path; repeatable.")
    parser.add_argument("--dry-run", action="store_true", help="Render prompts and list models without calling the API.")
    return parser.parse_args()


def process_model(
    *,
    index: int,
    total: int,
    path: Path,
    args: argparse.Namespace,
    template: Template,
    safe_root: Path,
    api_key: str,
    service_tier: str | None,
    prompt_cache_key: str | None,
    prompt_cache_retention: str | None,
) -> dict[str, Any]:
    rel = str(path.relative_to(ROOT))
    print(f"[{index}/{total}] {rel}", flush=True)
    safe_model_dir = safe_dir_for(safe_root, path)
    artifact_dir = artifact_dir_for(safe_model_dir) if not args.no_save_artifacts else None
    record: dict[str, Any] = {
        "path": rel,
        "safe_dir": str(safe_model_dir.relative_to(ROOT)),
        "started_at": utc_now(),
        "model": args.model,
        "reasoning_effort": args.reasoning_effort,
        "data_filename": args.data_filename,
    }
    if service_tier:
        record["service_tier"] = service_tier
    if prompt_cache_key:
        record["prompt_cache_key"] = prompt_cache_key
    if prompt_cache_retention:
        record["prompt_cache_retention"] = prompt_cache_retention
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
            write_result = write_translation(safe_model_dir, translation)
            record.update(write_result)
            record["protected_variables"] = translation.get("protected_variables", [])
            record["response_id"] = previous_record.get("response_id")
            record["usage"] = load_json(artifact_dir / "usage.json")
            record["skipped_existing_artifacts"] = True
            record["completed_at"] = utc_now()
            print(f"  -> {record['compatibility']} (skipped existing artifacts)", flush=True)
            save_model_record(artifact_dir, record)
            return record

        clear_translation_outputs(safe_model_dir)
        if artifact_dir is not None:
            clear_api_artifacts(artifact_dir)
        prompt = render_prompt(template, path, args.source_note_chars, args.data_filename)
        payload = response_payload(
            args.model,
            args.reasoning_effort,
            prompt,
            args.max_output_tokens,
            service_tier=service_tier,
            prompt_cache_key=prompt_cache_key,
            prompt_cache_retention=prompt_cache_retention,
        )
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
        write_result = write_translation(safe_model_dir, translation)
        record.update(write_result)
        record["protected_variables"] = translation.get("protected_variables", [])
        record["response_id"] = response.get("id")
        record["usage"] = response.get("usage")
        record["completed_at"] = utc_now()
        print(f"  -> {record['compatibility']}", flush=True)
    except Exception as error:  # noqa: BLE001 - batch runner records and continues.
        record["error"] = str(error)
        record["completed_at"] = utc_now()
        if artifact_dir is not None:
            write_text(artifact_dir / "error.txt", str(error))
        print(f"  !! {rel}: {error}", file=sys.stderr, flush=True)
    save_model_record(artifact_dir, record)
    return record


def main() -> int:
    args = parse_args()
    models_root = Path(args.models_root).expanduser().resolve()
    template_path = Path(args.template).expanduser().resolve()
    template = Template(template_path.read_text(encoding="utf-8"))
    safe_root = Path(args.safe_root).expanduser().resolve()

    candidates = model_dirs(models_root, args.data_filename)
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
            prompt = render_prompt(template, path, args.source_note_chars, args.data_filename)
            print(f"{path.relative_to(ROOT)} prompt_chars={len(prompt)}")
        return 0

    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        raise SystemExit("OPENAI_API_KEY is not set. Export it in the shell before running this script.")
    if args.workers < 1:
        raise SystemExit("--workers must be at least 1")

    run_id = args.run_id or utc_run_id()
    safe_root.mkdir(parents=True, exist_ok=True)
    service_tier = optional_string(args.service_tier)
    prompt_cache_key = optional_string(args.prompt_cache_key)
    prompt_cache_retention = optional_string(args.prompt_cache_retention)

    indexed_candidates = list(enumerate(candidates, start=1))
    results_by_index: dict[int, dict[str, Any]] = {}
    worker_count = min(args.workers, len(indexed_candidates)) if indexed_candidates else 1
    if worker_count == 1:
        for index, path in indexed_candidates:
            results_by_index[index] = process_model(
                index=index,
                total=len(candidates),
                path=path,
                args=args,
                template=template,
                safe_root=safe_root,
                api_key=api_key,
                service_tier=service_tier,
                prompt_cache_key=prompt_cache_key,
                prompt_cache_retention=prompt_cache_retention,
            )
            if args.sleep_seconds and index < len(candidates):
                time.sleep(args.sleep_seconds)
    else:
        with concurrent.futures.ThreadPoolExecutor(max_workers=worker_count) as executor:
            futures: dict[concurrent.futures.Future[dict[str, Any]], int] = {}
            for index, path in indexed_candidates:
                future = executor.submit(
                    process_model,
                    index=index,
                    total=len(candidates),
                    path=path,
                    args=args,
                    template=template,
                    safe_root=safe_root,
                    api_key=api_key,
                    service_tier=service_tier,
                    prompt_cache_key=prompt_cache_key,
                    prompt_cache_retention=prompt_cache_retention,
                )
                futures[future] = index
                if args.sleep_seconds and index < len(candidates):
                    time.sleep(args.sleep_seconds)
            for future in concurrent.futures.as_completed(futures):
                index = futures[future]
                try:
                    results_by_index[index] = future.result()
                except Exception as error:  # noqa: BLE001 - defensive guard for unexpected worker errors.
                    path = candidates[index - 1]
                    results_by_index[index] = {
                        "path": str(path.relative_to(ROOT)),
                        "started_at": utc_now(),
                        "completed_at": utc_now(),
                        "model": args.model,
                        "reasoning_effort": args.reasoning_effort,
                        "error": f"worker failed: {error}",
                    }
                    print(f"  !! {path.relative_to(ROOT)}: worker failed: {error}", file=sys.stderr, flush=True)

    results = [results_by_index[index] for index in sorted(results_by_index)]
    failures = sum(1 for record in results if "error" in record)

    summary = {
        "generated_at": utc_now(),
        "models_root": str(models_root),
        "safe_root": str(safe_root),
        "model": args.model,
        "reasoning_effort": args.reasoning_effort,
        "data_filename": args.data_filename,
        "service_tier": service_tier,
        "prompt_cache_key": prompt_cache_key,
        "prompt_cache_retention": prompt_cache_retention,
        "workers": worker_count,
        "run_id": run_id,
        "artifacts_root": str(safe_root),
        "total": len(results),
        "failures": failures,
        "results": results,
    }
    write_json(Path(args.output).expanduser().resolve(), summary)
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
