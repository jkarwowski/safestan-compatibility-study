#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))

from scripts.run_cmdstan_model import main

if __name__ == "__main__":
    raise SystemExit(main(["--model-dir", str(Path(__file__).resolve().parent), *sys.argv[1:]]))
