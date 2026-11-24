#!/usr/bin/env python3
"""Preserve pinned upstream license notices for the imported Stack subset.

Uses the current gh login without storing credentials. Missing upstream notices
are recorded explicitly; repository license labels remain dataset evidence.
"""
import argparse
import base64
from concurrent.futures import ThreadPoolExecutor, as_completed
import hashlib
import json
from pathlib import Path
import subprocess
import threading
import time

ROOT = Path(__file__).resolve().parents[1]
LOCK = threading.Lock()
NEXT_REQUEST = 0.0


def fetch(snapshot, cache):
    global NEXT_REQUEST
    repo, commit = snapshot
    key = hashlib.sha256((repo + "@" + commit).encode()).hexdigest()
    target = cache / (key + ".json")
    if target.exists():
        return json.loads(target.read_text())
    with LOCK:
        delay = max(0, NEXT_REQUEST - time.monotonic())
        NEXT_REQUEST = time.monotonic() + delay + 0.3
    time.sleep(delay)
    result = subprocess.run(["gh", "api", "--method", "GET", f"repos/{repo}/license", "-f", f"ref={commit}"], capture_output=True, text=True, timeout=45)
    record = {"repository": repo, "commit": commit}
    if result.returncode:
        # Only record the HTTP status, not arbitrary CLI diagnostics.
        try:
            status = json.loads(result.stdout).get("status")
        except json.JSONDecodeError:
            status = None
        if str(status) not in {"404", "451"}:
            raise RuntimeError(f"License fetch failed for {repo}: HTTP {status or 'unknown'}")
        record.update(status="unavailable", http_status=status)
    else:
        data = json.loads(result.stdout)
        if data.get("encoding") != "base64":
            raise ValueError("Unsupported license encoding: " + repo)
        content = base64.b64decode(data["content"])
        digest = hashlib.sha256(content).hexdigest()
        git_sha = hashlib.sha1(b"blob " + str(len(content)).encode() + b"\0" + content).hexdigest()
        if git_sha != data["sha"]:
            raise ValueError("License blob mismatch: " + repo)
        record.update(status="saved", path=data["path"], git_blob_sha1=git_sha,
                      sha256=digest, license_id=(data.get("license") or {}).get("spdx_id"),
                      source_url=f"https://github.com/{repo}/blob/{commit}/{data['path']}",
                      content_base64=base64.b64encode(content).decode())
    target.write_text(json.dumps(record, sort_keys=True) + "\n")
    return record


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cache", type=Path, required=True)
    args = parser.parse_args()
    args.cache.mkdir(parents=True, exist_ok=True)
    root = ROOT / "imports/the_stack"
    rows = [json.loads(line) for line in (root / "selection.jsonl").read_text().splitlines()]
    snapshots = sorted({(r["repository"], r["commit"]) for r in rows})
    results = []
    with ThreadPoolExecutor(max_workers=4) as pool:
        for future in as_completed([pool.submit(fetch, s, args.cache) for s in snapshots]):
            results.append(future.result())
            if len(results) % 100 == 0:
                print(f"License snapshots: {len(results)}/{len(snapshots)}", flush=True)
    dest = root / "licenses"
    dest.mkdir(exist_ok=True)
    for r in results:
        if r["status"] == "saved":
            path = dest / (r["sha256"] + ".txt")
            path.write_bytes(base64.b64decode(r.pop("content_base64")))
            r["local_path"] = path.relative_to(ROOT).as_posix()
    (root / "license_notices.json").write_text(json.dumps(sorted(results, key=lambda r: (r["repository"], r["commit"])), indent=2, sort_keys=True) + "\n")
    print(json.dumps({"snapshots": len(results), "saved": sum(r['status']=='saved' for r in results), "unique_notices": len(list(dest.glob('*.txt')))}))


if __name__ == "__main__":
    main()
