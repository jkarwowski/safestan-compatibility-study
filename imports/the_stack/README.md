# The Stack Stan import

This subset adds 2,296 Stan model directories under `models/the_stack/` using the existing corpus layout. It comes from **bigcode/the-stack-dedup**, not The Pile. The original 1,193 model directories and their SafeStan/comparison results are unchanged.

Access and use of this subset requires agreement to the [Terms of Use](TERMS_OF_USE.txt). If you do not agree, do not access or use `models/the_stack/`. The original source licenses continue to apply. Repository license labels are retained as dataset evidence; they are not new licenses granted by this repository. Source comments and notices are preserved. [Pinned upstream license notices](license_notices.json) link repository/commit pairs to the available texts in `licenses/`; unavailable notices are explicitly recorded. Maintain this subset in accordance with upstream removal/version updates.

The license lookup recovered notices for 781 of 848 repository/commit snapshots (629 distinct texts). The remaining 67 lookups were unavailable; these cover 231 candidates whose original dataset license labels and source attribution are still preserved. All non-ambiguous GitHub license detections for recovered notices agree with the corresponding dataset labels.

## Contents and selection

- 2,296 candidates from 847 representative repositories, selected from the 5,441-file Stan shard.
- 442 compile in their original form; 1,854 use the existing corpus syntax modernizer. The latter preserve upstream bytes in `model_original.stan` beside the runner's `model.stan`.
- All 2,296 imported programs pass stanc; 540 have no pedantic warnings.
- Every entry has `model.stan`, `data.json`, `metadata.json`, `source.md`, and the existing thin `run.py` wrapper.
- Every entry has synthetic data: 2,239 generated through stanc and 57 through the existing parser fallback. All generated JSON is finite and contains exactly the compiler-declared input keys. Shape/constraint and runtime correctness are not established by those checks.
- `licenses` is the only new per-model metadata field. Provenance uses the existing upstream repository/commit/path fields. Detailed audit facts live in the shared manifest rather than extending every metadata record.

The prior audit excluded identified local overlaps, compiler fixtures, input duplicates, fragments, and models that failed compilation. Candidates require data inputs, parameters, a density-like model block, and a reference to input in that block. Lexical near-deduplication uses five-token shingle Jaccard similarity at 0.85. These are model candidates, not a count of semantically distinct model families. The selection is fixed here; it is not rerun during import.

`dataset.json` pins the dataset revision, shard hash, selection hash, compiler hash, and original audit/modernizer hashes. `selection.jsonl` contains one candidate per row, including original/imported hashes, upstream provenance, compiler interfaces, repair counts, and review flags. [MODEL_LIST.md](MODEL_LIST.md) provides a browsable index.

Two selected Stack records contain resolved symlink contents. Their manifest/source notes identify the link target and the upstream verification: the dataset's Git blob identifier names the symlink, while the SHA-256 identifies the preserved source contents.

No observation datasets were recovered. The synthetic data uses `scripts/generate_synthetic_data_for_missing.py`: stanc's `--debug-generate-data`, existing shape/index postprocessing, then a data-block parser fallback when stanc cannot generate data. This is small schema-driven test data, not draws from the model's generative process or a replacement for scientific observations. The bounded import wrapper records failed generation as an explicit missing-data placeholder; no placeholders remain in this import.

The saved [validation report](../../runs_metadata/the_stack_import_validation.json) covers source hashes, corpus layout, metadata, JSON/input-key coverage, and stanc parsing/type checking/C++ generation. It does not establish C++ build success, successful sampling, posterior propriety, semantic correctness of modernization, or SafeStan compatibility. Warnings and original source are retained for subsequent curation.

## Reproduce the import

Accept access to [bigcode/the-stack-dedup](https://huggingface.co/datasets/bigcode/the-stack-dedup), authenticate locally with Hugging Face, and download `data/stan/data-00000-of-00001.parquet` at revision `17cad72c886a2858e08d4c349a00d6466f54df63`. Install `pyarrow` in the Python environment used for importing.

The importer checks the shard/source/transformed hashes and refuses to overwrite existing model directories. Use an empty destination to reproduce without touching the checked-in corpus:

```sh
python3 scripts/import_stack_stan_models.py \
  --parquet /path/to/data-00000-of-00001.parquet \
  --models-root /tmp/stack-reproduction/models \
  --stanc /path/to/cmdstan/bin/stanc \
  --accept-stack-terms
```

`--audit-dir /path/to/stack-stan-audit/outputs/full` can replace `--parquet` when the original audit source files are available. `--skip-data` produces explicitly marked missing-data placeholders. Regenerating synthetic data can produce different values; the checked-in source and data are the fixed snapshot for this import.

To validate the checked-in import:

```sh
python3 -m unittest discover -s scripts -p test_import_stack_stan_models.py
python3 scripts/validate_stack_stan_models.py --stanc /path/to/cmdstan/bin/stanc
```

To retrieve available upstream license notices again using a local GitHub CLI login:

```sh
python3 scripts/fetch_stack_license_notices.py --cache /tmp/stack-license-cache
```

The source snapshot is The Stack v1, discovered through GHArchive and downloaded from public GitHub repositories in 2021–2022. The full dataset and methodology are described in [The Stack dataset card](https://huggingface.co/datasets/bigcode/the-stack-dedup). This repository contains only the selected Stan subset and its provenance, not the entire shard.
