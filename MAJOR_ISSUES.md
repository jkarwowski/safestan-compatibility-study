# Major SafeStan Blocker Issues

This analysis covers the `461` local artifacts classified as `major` in `RESULTS.md`.

The review was manual and split by source family. The primary blocker table is non-overlapping and sums to `461`. Many models have secondary blockers as well, so the feature tiers should be read as "primary blocker resolved" counts, not as a guarantee that every model in that tier would need only one language change.

## Primary Blockers

| Primary blocker | Count | Representative models | What is missing |
|---|---:|---|---|
| Missing, improper, or otherwise invalid parameter-prior discipline | 206 | `stan_tutorials/simple-regression`, `posteriordb/wells-data-wells-dae-model`, `example_models/arm-ch-16-radon-2`, `example_models/education-tutorial-twopl-reg-dif`, `betanalpha_knitr_case_studies/bayes-sparse-regression-linear-regression-unif` | A SafeStan policy for explicit flat/improper priors, bounded uniform priors as priors, and mechanical prior-vectorization over matrices/arrays without changing density. |
| Custom, marginalized, or procedural protected-data likelihood | 183 | `forestdb/adjectives`, `forestdb/finite-gaussian-mixture`, `stan_tutorials/k-component-normal-mixture`, `example_models/bpa-ch-12-nmix0`, `example_models/misc-cluster-lda-corr-lda`, `posteriordb/hmm-gaussian-simulated-hmm-gaussian` | Built-in protected-observation primitives for mixtures, HMMs/forward algorithms, capture-recapture histories, LDA/topic models, N-mixture/occupancy models, and other normalized finite-latent likelihoods. |
| Protected-data interface/layout mismatch | 36 | `bda_r_demos/demos-rstan-lin-std`, `example_models/arm-ch-4-logearn-height`, `example_models/basic-estimators-normal-multi`, `posteriordb/bones-data-bones-model`, `example_models/bugs-examples-vol1-lsat-lsat` | A disciplined data-interface rewrite mechanism for transformed, expanded, split, ragged, sliced, or row-wise protected observations. |
| Custom/manual/non-top-level parameter prior or latent-process prior | 32 | `stan_case_studies/bym2-spatial-poisson`, `example_models/knitr-car-iar-poisson-bym2`, `example_models/jupyter-sum-to-zero-stan-bym2-soft`, `betanalpha_knitr_case_studies/brownian-bridge-stan-programs-fit-ou-analytic-all-t`, `posteriordb/traffic-accident-nyc-bym2-offset-only` | Trusted prior families or certification for ICAR/CAR/GMRF, Brownian/OU/state-process priors, determinant/P-spline penalties, and user-defined prior densities. |
| Conditional `prior_only`-style likelihood gate | 3 | `posteriordb/diamonds-diamonds`, `posteriordb/mcycle-gp-accel-gp`, `posteriordb/mcycle-splines-accel-splines` | A policy for data-independent likelihood gates or a preprocessing rule that selects the observed-likelihood branch before SafeStan checking. |
| Compiler/regression stress case rather than a model translation | 1 | `example_models/regression-tests-mother` | Treat as a compiler stress test, not as an applied-model compatibility target. |

## Manual Review Partitions

| Review partition | Major cases | Main pattern |
|---|---:|---|
| `forestdb`, `stan_case_studies`, `stan_tutorials`, `bda_r_demos`, `stancon_talks` | 95 | Mostly custom/marginalized likelihoods, with a smaller block of missing priors and transformed observations. |
| `betanalpha_knitr_case_studies` | 37 | Mix of missing priors, manual protected likelihoods, latent-process priors, and custom prior densities. |
| `posteriordb` | 75 | Mostly missing/improper priors, followed by procedural observation likelihoods and a few ragged/conditional interfaces. |
| `example_models` first major block | 127 | ARM-style missing priors dominate; capture-history and transformed-response cases are also common. |
| `example_models` middle major block | 39 | Mostly BPA capture-recapture, multistate, N-mixture, IPM, and derived-event likelihoods. |
| `example_models` later major block | 88 | Missing priors, custom likelihoods, CAR/ICAR-style priors, transformed protected data, and one stress test. |
| **Total** | **461** |  |

## Feature Tiers

These tiers are cumulative over primary blockers and assume the current minor-rewrite methodology remains acceptable: deterministic data augmentation, reshaping, vectorization, and reordering that preserves the normalized density.

| Tier | Added SafeStan capability or policy | Newly resolved primary blockers | Cumulative resolved | Notes |
|---|---|---:|---:|---|
| 1 | Parameter-prior policy: explicit flat/improper priors, bounded uniform priors, and matrix/array prior-vectorization | 206 | 206 | This is still the largest blocker. It covers many GLM, regression, IRT, and MLE-style examples whose protected likelihood is otherwise ordinary. |
| 2 | Observation-side primitives for finite-latent and procedural likelihoods | 183 | 389 | Highest-value language work after priors: finite mixtures, HMMs, LDA/topic models, capture-recapture histories, N-mixture/occupancy, Skellam/hurdle/custom race likelihoods, and similar normalized constructions. |
| 3 | Protected-data interface rewrite support | 36 | 425 | Covers models that observe transformed, expanded, split, ragged, sliced, row-wise, or otherwise non-top-level data. |
| 4 | Trusted custom prior/process families | 32 | 457 | Covers ICAR/CAR/GMRF, Brownian bridge, OU/state-space, P-spline/determinant penalties, and other parameter-side processes. |
| 5 | Conditional likelihood-gate policy | 3 | 460 | Mostly `prior_only` flags. These are easy to identify but require a language or preprocessing decision. |
| 6 | Exclude or separately classify compiler/regression stress programs | 1 | 461 | `regression-tests-mother` is not a representative applied-model blocker. |

## Practical Takeaways

- The full dataset changes the picture from the small study: missing/improper priors remain the largest single category, but custom or marginalized protected likelihoods are nearly as common.
- Many major cases are not "Stan syntax" problems. They encode normalized likelihoods procedurally with `target +=`, `log_mix`, `log_sum_exp`, forward algorithms, or user-defined density functions. SafeStan would need trusted primitives, not just a looser parser, to accept these safely.
- Protected-data interface issues are a distinct class. They arise when the observed object is computed from data, represented as ragged slices, split into multiple top-level variables, or scored row-wise/index-wise rather than as a single protected observation.
- The generated safe translations also need a validation pass. The latest smoke check found `93` generated safe models that still do not run after rechecking, including `61` compile-time errors in generated `model_safe.stan` files. These are translation-quality failures, not `major` compatibility blockers.
