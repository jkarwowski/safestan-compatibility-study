# SafeStan Compatibility Results

This report covers the full local corpus: `1193` Stan model directories under `models/` and mirrored under `models_safe/`.

Compatibility totals below are deduplicated. The raw corpus includes 30 curated rows in `stan_case_studies` and `stan_tutorials` that are source-identical copies of rows in `example_models`; those rows are retained in `MODEL_LIST.md` for inventory completeness but excluded from "Compatibility Totals" here. No within-source variants were collapsed.

Counts use the on-disk artifacts in `models_safe/*/*/api/record.json` and the matching `SAFETY_NOTE.md` files. The absolute-path run summary in `runs_metadata/openai_safestan_generation_latest.json` reports `320` as-is, `416` minor, and `457` major, but it disagrees with the local artifact tree on six models. For this repository state, the local artifacts are the authoritative source.

Model/API: `gpt-5.5` with reasoning effort `high`, Flex service tier, prompt cache key `safestan-translation-v1`.

API usage stored in the local artifacts: `6116846` input tokens, `2317312` cached input tokens, `3316659` output tokens, including `2731134` reasoning output tokens.

Original Stan smoke test: `runs_metadata/full-dataset-smoke-clean-20260429T0015Z.json` ran all `1193` original models with `1` chain, `20` warmup draws, and `20` sampling draws; result `1193` ok, `0` failed.

## Compatibility Totals

Raw artifact inventory: `1193` models: `320` as-is, `412` minor, `461` major.

Excluded duplicates: `30` source-identical rows: `5` as-is, `6` minor, and `19` major. All 30 are `stan_case_studies` or `stan_tutorials` rows borrowed from `example_models`; see the `Duplicate of` column in `MODEL_LIST.md`.

Deduplicated compatibility units: `1163` models. Compatibility totals: `315` as-is, `406` minor, `442` major.

SafeStan output files were generated for all `721` deduplicated as-is/minor artifact records: `315` as-is and `406` minor. Of those, `544` have at least one protected variable and `177` have no protected data interface.

| Source family | Models | as-is | minor | major | Safe files | No protected data |
|---|---:|---:|---:|---:|---:|---:|
| `bda_r_demos` | 14 | 9 | 2 | 3 | 11 | 0 |
| `betanalpha_knitr_case_studies` | 302 | 183 | 82 | 37 | 265 | 139 |
| `example_models` | 538 | 82 | 202 | 254 | 284 | 36 |
| `forestdb` | 101 | 20 | 37 | 44 | 57 | 0 |
| `posteriordb` | 147 | 14 | 58 | 75 | 72 | 0 |
| `stancon_talks` | 61 | 7 | 25 | 29 | 32 | 2 |
| **Total** | **1163** | **315** | **406** | **442** | **721** | **177** |

## No-Protected-Data Models

The `177` no-protected-data rows are counted as SafeStan-compatible when their artifact result is `as-is` or `minor`. They have no observed top-level data variable to protect. The initial smoke runner treated many of them as failures only because `stanc --sstanc` requires at least one `--sstan-protect` name; the targeted recheck compiled these in plain mode.

There are several shapes in this group.

Prior-only parameter model, for example `example_models/basic-distributions-normal`:

```stan
parameters {
  real y;
}
model {
  y ~ normal(0, 1);
}
```

Prior-only model with context data, for example `betanalpha_knitr_case_studies/brownian-bridge-stan-programs-brownian-bridge-prior-ncp`:

```stan
data {
  int<lower=1> N;
  array[N] real ts;
  real x_left;
  real x_right;
  array[N - 2] int left_idxs;
  array[N - 2] int center_idxs;
  array[N - 2] int right_idxs;
}
parameters {
  array[N - 2] real interior_x_tildes;
}
model {
  interior_x_tildes ~ normal(0, 1);
}
```

Prior-predictive or generated-quantities simulator, for example `example_models/knitr-simplest-regression-fake-data`:

```stan
data {
  int<lower=1> N;
  real a;
  real b;
  real<lower=0> sigma;
  vector[N] x;
}
generated quantities {
  vector[N] y;
  for (n in 1:N) {
    y[n] = normal_rng(a + b * x[n], sigma);
  }
}
```

Pure data simulator with no data block, for example `betanalpha_knitr_case_studies/bayes-sparse-regression-generate-data`, defines constants in `transformed data` and simulates `X`, `beta`, and `y` in `generated quantities`. It has no likelihood and no protected observation.

## SafeStan Smoke Check

The smoke check ran over the raw generated safe-model directories. That raw set has `732` generated SafeStan outputs; the deduplicated set has `721` because the 11 safe duplicate rows all passed and are excluded from compatibility totals.

First pass: `runs_metadata/cmdsafestan-safe-smoke-20260429T165345Z.json` tested all `732` raw generated safe models through the repository runner. Result: `467` ok, `265` failed. Of the failures, `177` were no-protected-data models that cannot be invoked with `stanc --sstanc` because SafeStan requires `--sstan-protect`.

Targeted recheck: `runs_metadata/cmdsafestan-safe-smoke-recheck-20260429T170612Z.json` reran the `265` first-pass failures. No-protected-data models were compiled via `cmdsafestan --mode plain`; protected models were rerun with the current SafeStan wrapper and `init=0`. Recheck result: `172` ok, `93` failed.

Combined raw result after recheck: `639` of `732` generated safe models run successfully; `93` still fail.

Combined deduplicated result after removing the 11 passing duplicate safe rows: `628` of `721` generated safe models run successfully; `93` still fail.

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

## Major Feature Analysis

The `442` deduplicated major cases were reviewed manually in source-family batches. The table is non-overlapping by primary blocker; many models also have secondary issues.

| Source partition | Major cases | Add priors | Finite mixture | Other observation primitives | Custom prior/process primitives | Data-interface rewrite | Other/out of scope |
|---|---:|---:|---:|---:|---:|---:|---:|
| `example_models` | 254 | 113 | 13 | 65 | 30 | 32 | 1 |
| `posteriordb` | 75 | 32 | 5 | 20 | 2 | 13 | 3 |
| `betanalpha_knitr_case_studies` | 37 | 12 | 13 | 2 | 8 | 0 | 2 |
| `forestdb`, `bda_r_demos`, `stancon_talks` | 76 | 7 | 9 | 22 | 3 | 5 | 30 |
| **Total** | **442** | **164** | **40** | **109** | **43** | **50** | **36** |

Feature-scenario interpretation among the `442` major cases:

| Scenario | Newly added major models | Cumulative added | Dedup compatible total |
|---|---:|---:|---:|
| Add explicit priors or allow flat/improper/no-prior cases | 164 | 164 | 885 / 1163 |
| Also add a built-in finite mixture operator | 40 | 204 | 925 / 1163 |
| Also add self-contained observation primitives similar to mixture | 109 | 313 | 1034 / 1163 |
| Also add custom prior/process primitives | 43 | 356 | 1077 / 1163 |
| Also add protected-data interface rewrites | 50 | 406 | 1127 / 1163 |

The "self-contained observation primitives" bucket includes HMM/forward algorithms, capture-recapture and occupancy/N-mixture likelihoods, LDA/topic and noisy-rater latent-class likelihoods, censoring/truncation/survival likelihoods, Skellam/hurdle/GPD/race/LBA kernels, ordinal IRT kernels, Kronecker-GP observation likelihoods, and a small number of GARCH/time-series conditional likelihoods.

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
