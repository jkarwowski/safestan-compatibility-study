# Stan/SafeStan Regression Model Collection

This repository contains a small, uniform corpus of Stan models for comparing original Stan programs with SafeStan translations through a CmdStan-compatible runner such as `cmdsafestan`.

## Layout

Each model directory contains:

- `model.stan`: the Stan model to compile.
- `data.json`: the default data set for the model.
- `metadata.json`: source, difficulty, and default run settings.
- `source.md`: upstream link and translation notes.
- `run.py`: thin wrapper around `scripts/run_cmdstan_model.py`.

Model groups live under `models/stan_tutorials`, `models/stan_case_studies`, and `models/forestdb`.

## Running One Model

```sh
python3 models/forestdb/binomial-inference/run.py --cmdstan /path/to/cmdsafestan
```

You can also set `CMDSAFESTAN` or `CMDSTAN`:

```sh
CMDSAFESTAN=/path/to/cmdsafestan python3 models/forestdb/binomial-inference/run.py
```

By default each model uses 4 chains, 250 warmup iterations, and 250 sampling iterations. Override these with `--chains`, `--iter-warmup`, and `--iter-sampling`.

## Running a Suite

```sh
python3 scripts/run_suite.py --cmdstan /path/to/cmdsafestan --source forestdb
python3 scripts/run_suite.py --cmdstan /path/to/cmdsafestan --difficulty advanced --limit 5
```

Use `--dry-run` to inspect compile and run commands without executing them.

## Comparing Runs

After running a Stan baseline and a SafeStan candidate into separate output roots:

```sh
python3 scripts/compare_outputs.py runs/baseline runs/safestan --json-output runs/comparison.json
```

The comparison script summarizes common CmdStan CSV columns and checks mean and standard-deviation differences with configurable `--atol` and `--rtol`.

## Checking SafeStan Compatibility

With a built SafeStan compiler:

```sh
python3 scripts/check_safestan_compatibility.py \
  --stanc /path/to/cmdsafestan/safestan/_build/default/src/stanc/stanc.exe \
  --write
```

This writes `safestan_compatibility.json`, refreshes `RESULTS.md`, and updates the SafeStan markers in `MODEL_LIST.md`.

The full `stan-dev/example-models` snapshot can be materialized and audited separately:

```sh
python3 scripts/bootstrap_all_stan_examples.py \
  --stanc /path/to/cmdsafestan/safestan/_build/default/src/stanc/stanc.exe \
  --force
python3 scripts/check_safestan_compatibility.py \
  --manifest expanded_model_manifest.json \
  --json-output safestan_compatibility_all.json \
  --results-output ALL_RESULTS.md \
  --model-list-output ALL_MODEL_LIST.md \
  --stanc /path/to/cmdsafestan/safestan/_build/default/src/stanc/stanc.exe \
  --write
```

The expanded bootstrap copies upstream same-stem JSON data when present and otherwise writes synthetic data from `stanc --debug-generate-data`.

## Validating Minor SafeStan Rewrites

`MINOR` compatibility is only confirmed when an explicit `model_safe.stan` exists and an original-vs-safe run comparison passes. Generate conservative safe rewrites and run the comparison with:

```sh
python3 scripts/validate_minor_models.py \
  --manifest expanded_model_manifest.json \
  --compatibility safestan_compatibility_all.json \
  --json-output minor_validation_all.json \
  --md-output MINOR_VALIDATION_ALL.md \
  --results-md ALL_RESULTS.md \
  --model-list-md ALL_MODEL_LIST.md \
  --run \
  --write-report-markers
```

For the curated 45-model set, use `model_manifest.json`, `safestan_compatibility.json`, `minor_validation.json`, `MINOR_VALIDATION.md`, `RESULTS.md`, and `MODEL_LIST.md`.

## SafeStan Translation Workflow

A simple workflow is to keep the original `model.stan`, add a translated SafeStan file such as `model_safe.stan` in the same directory, and run:

```sh
python3 models/forestdb/binomial-inference/run.py --cmdstan /path/to/cmdsafestan --stan-file model_safe.stan --output-dir runs/safestan/forestdb/binomial-inference
```

If your SafeStan compiler expects a different extension, pass that filename with `--stan-file`; the runner compiles the executable target by stripping the file suffix.
