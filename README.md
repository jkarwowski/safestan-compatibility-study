# Stan/SafeStan Regression Model Collection

This repository is a small regression corpus for comparing original Stan models against SafeStan-compatible translations. It contains 45 model directories from three sources: ForestDB translations, Stan case studies, and Stan tutorial/example models.

Each model directory has the same shape:

```text
models/<category>/<model>/
  model.stan          # original Stan program
  data.json           # data for the original program
  metadata.json       # source, difficulty, and default run settings
  source.md           # source provenance
  run.py              # thin wrapper around scripts/run_cmdstan_model.py
```

SafeStan outputs mirror the model tree:

```text
models_safe/<category>/<model>/
  SAFETY_NOTE.md      # SafeStan compatibility note
  model_safe.stan     # generated only for as-is/minor models
  data_safe.json      # generated only for as-is/minor models
  api/                # prompt, request, response, parsed JSON, usage, record
```

## Files

- `MODEL_LIST.md` lists the 45 models, source links, data provenance, and descriptions.
- `RESULTS.md` records the SafeStan compatibility labels, generated-file status, token usage, and notes.
- `models_safe/<category>/<model>/api/` stores reproducibility artifacts for each API translation call: prompt, request, raw response, parsed translation, usage, and record.
- `runs_metadata/openai_safestan_generation_models_safe_full45.json` is the full 45-model run summary.

## Requirements

- Python 3.10 or newer.
- A CmdStan-compatible toolchain. For SafeStan tests, set `CMDSAFESTAN` to your cmdsafestan checkout/root. For ordinary Stan tests, set `CMDSTAN` or pass `--cmdstan` explicitly.
- `OPENAI_API_KEY` is only needed if you regenerate SafeStan translations with the OpenAI API script.

## Run One Original Model

```sh
export CMDSTAN=/path/to/cmdstan
python3 models/forestdb/gaussian-inference/run.py
```

Equivalent explicit form:

```sh
python3 scripts/run_cmdstan_model.py --model-dir models/forestdb/gaussian-inference --cmdstan /path/to/cmdstan
```

Outputs are written to `models/<category>/<model>/runs/<UTC timestamp>/` unless `--output-dir` is passed.

## Run A SafeStan Translation

Safe files exist only for models marked `as-is` or `minor` in `RESULTS.md`.

```sh
export CMDSAFESTAN=/path/to/cmdsafestan
python3 models/forestdb/gaussian-inference/run.py --safe
```

The runner reads `models_safe/<category>/<model>/api/translation.json` and passes the recorded protected variables to `cmdsafestan` at compile time. To override them manually:

```sh
python3 models/forestdb/gaussian-inference/run.py --safe --sstan-protect y
```

For models without `model_safe.stan`/`data_safe.json`, the SafeStan translation was classified as `major` and intentionally not produced.
SafeStan run outputs are written to `models_safe/<category>/<model>/runs/<UTC timestamp>/` unless `--output-dir` is passed.

## Useful Runner Options

```sh
# Print compile/run commands without executing them
python3 models/forestdb/gaussian-inference/run.py --dry-run

# Use fewer iterations for a quick smoke test
python3 models/forestdb/gaussian-inference/run.py --chains 1 --iter-warmup 50 --iter-sampling 50

# Force recompilation
python3 models/forestdb/gaussian-inference/run.py --force-recompile

# Use an explicit output directory
python3 models/forestdb/gaussian-inference/run.py --output-dir /tmp/gaussian-original
```

## Compare Stan And SafeStan Results

The comparison script runs original Stan and generated SafeStan versions in an isolated `comparison_runs/<run_id>/` tree, compares common posterior columns by summary statistics, and also spot-checks `log_prob`/gradient equality on draws from the original model.

```sh
export CMDSAFESTAN=/path/to/cmdsafestan
python3 scripts/compare_safestan_results.py \
  --chains 1 \
  --iter-warmup 200 \
  --iter-sampling 200 \
  --log-prob-checks 3
```

Use `--only <model-id>` for a single model smoke test.

## Regenerate SafeStan Translations

The generator uses `gpt-5.5` with reasoning effort `high` by default and saves full per-call artifacts. It skips models that already have complete artifacts in `models_safe/<category>/<model>/api/` unless `--rerun-existing-artifacts` is passed.

```sh
set -a; source .env; set +a
python3 scripts/generate_safestan_with_openai.py \
  --run-id models-safe-high-20260428T004612Z \
  --safe-root models_safe \
  --reasoning-effort high \
  --max-output-tokens 64000 \
  --timeout 900 \
  --retries 2 \
  --output runs_metadata/openai_safestan_generation_models_safe_full45.json
```

Use `--only <suffix>` to translate a single model directory and `--dry-run` to inspect prompt sizes without calling the API.
