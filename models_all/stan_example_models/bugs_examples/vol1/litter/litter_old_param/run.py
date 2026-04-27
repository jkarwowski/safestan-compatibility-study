#!/usr/bin/env python3
from pathlib import Path
import sys

HERE = Path(__file__).resolve()
ROOT = next(parent for parent in HERE.parents if (parent / "scripts" / "run_cmdstan_model.py").exists())
sys.path.insert(0, str(ROOT))

from scripts.run_cmdstan_model import main

if __name__ == "__main__":
    raise SystemExit(main(["--model-dir", str(HERE.parent), *sys.argv[1:]]))
