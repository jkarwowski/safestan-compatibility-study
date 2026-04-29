# SafeStan Compatibility Results

This report covers the full local corpus: `1193` Stan model directories mirrored under `models_safe/`.

Counts below use the on-disk artifacts in `models_safe/*/*/api/record.json` and the matching `SAFETY_NOTE.md` files. The absolute-path run summary in `runs_metadata/openai_safestan_generation_latest.json` reports `320` as-is, `416` minor, and `457` major, but it disagrees with the local artifact tree on six models. For this repository state, the local artifacts are the authoritative source.

Model/API: `gpt-5.5` with reasoning effort `high`, Flex service tier, prompt cache key `safestan-translation-v1`.

API usage stored in the local artifacts: `6116846` input tokens, `2317312` cached input tokens, `3316659` output tokens, including `2731134` reasoning output tokens.

Original Stan smoke test: `runs_metadata/full-dataset-smoke-clean-20260429T0015Z.json` ran all `1193` original models with `1` chain, `20` warmup draws, and `20` sampling draws; result `1193` ok, `0` failed.

## Compatibility Totals

Processed `1193` models. Compatibility totals: `320` as-is, `412` minor, `461` major.

SafeStan output files were generated for all `732` as-is/minor artifact records: `320` as-is and `412` minor. Of those, `555` have at least one protected variable and `177` are prior-only, simulation, or generated-quantities programs with no protected data interface.

| Source family | Models | as-is | minor | major | Safe files | No protected data |
|---|---:|---:|---:|---:|---:|---:|
| `bda_r_demos` | 14 | 9 | 2 | 3 | 11 | 0 |
| `betanalpha_knitr_case_studies` | 302 | 183 | 82 | 37 | 265 | 139 |
| `example_models` | 538 | 82 | 202 | 254 | 284 | 36 |
| `forestdb` | 101 | 20 | 37 | 44 | 57 | 0 |
| `posteriordb` | 147 | 14 | 58 | 75 | 72 | 0 |
| `stan_case_studies` | 15 | 2 | 6 | 7 | 8 | 0 |
| `stan_tutorials` | 15 | 3 | 0 | 12 | 3 | 0 |
| `stancon_talks` | 61 | 7 | 25 | 29 | 32 | 2 |
| **Total** | **1193** | **320** | **412** | **461** | **732** | **177** |

## SafeStan Smoke Check

I ran `cmdsafestan` over the generated safe models with `1` chain, `20` warmup draws, and `20` sampling draws.

First pass: `runs_metadata/cmdsafestan-safe-smoke-20260429T165345Z.json` tested all `732` generated safe models through the repository runner. Result: `467` ok, `265` failed. Of the failures, `177` were no-protected-data models that cannot be invoked with `stanc --sstanc` because SafeStan requires `--sstan-protect`.

Targeted recheck: `runs_metadata/cmdsafestan-safe-smoke-recheck-20260429T170612Z.json` reran the `265` first-pass failures. No-protected-data models were compiled via `cmdsafestan --mode plain`; protected models were rerun with the current SafeStan wrapper and `init=0`. Recheck result: `172` ok, `93` failed.

Combined result after recheck: `639` of `732` generated safe models run successfully; `93` still fail.

| Final failure reason | Count | Notes |
|---|---:|---|
| Compile-time Stan/SafeStan error | 61 | Generated `model_safe.stan` is not accepted by `stanc`, usually because a translation used an unsupported array/matrix sampling form or otherwise produced invalid Stan. |
| Initialization failure | 21 | Compilation succeeds, but short sampling fails to find a valid initial state even with `init=0`. |
| Runtime exception after compile | 11 | Compilation succeeds, but transformed data, log-probability evaluation, or sampling fails at runtime. |
| **Total** | **93** | 88 protected SafeStan runs and 5 no-protected-data plain-mode runs. |

| Source family | Compile | Init | Runtime | Final failures |
|---|---:|---:|---:|---:|
| `bda_r_demos` | 0 | 1 | 0 | 1 |
| `betanalpha_knitr_case_studies` | 3 | 10 | 2 | 15 |
| `example_models` | 30 | 7 | 6 | 43 |
| `forestdb` | 10 | 0 | 0 | 10 |
| `posteriordb` | 8 | 0 | 3 | 11 |
| `stancon_talks` | 10 | 3 | 0 | 13 |
| **Total** | **61** | **21** | **11** | **93** |

## Major Blockers

The `461` major cases were reviewed manually in source-family batches. The primary blocker counts are:

| Primary blocker | Count |
|---|---:|
| Missing, improper, or otherwise invalid parameter-prior discipline | 206 |
| Custom, marginalized, or procedural protected-data likelihood | 183 |
| Protected-data interface/layout mismatch | 36 |
| Custom/manual/non-top-level parameter prior or latent-process prior | 32 |
| Conditional `prior_only`-style likelihood gate | 3 |
| Compiler/regression stress case rather than a model translation | 1 |
| **Total** | **461** |

See `MAJOR_ISSUES.md` for the blocker taxonomy, examples, and feature-tier interpretation.

## Artifact Consistency Note

`runs_metadata/openai_safestan_generation_latest.json` points at an absolute artifact root outside this checkout and differs from the checked-out local artifacts on six models:

| Model | Run summary | Local artifact |
|---|---|---|
| `example_models/applications-covid-19-imperial-model-imperial-model` | minor | major |
| `example_models/bpa-ch-08-mr-mnl-age` | minor | major |
| `example_models/bugs-examples-vol1-bones-bones` | major | minor |
| `example_models/bugs-examples-vol1-leukfr-leukfr` | minor | major |
| `example_models/bugs-examples-vol1-lsat-lsat` | minor | major |
| `posteriordb/ecdc0501-covid19imperial-v3` | minor | major |

This report uses the local `record.json`/`SAFETY_NOTE.md` artifacts because those are the files present in this repository and the files exercised by the `cmdsafestan` smoke checks.
