# Major SafeStan Blocker Issues

This analysis covers the `442` deduplicated local artifacts classified as `major` in `RESULTS.md`.

The raw artifact tree has `461` major rows. The difference is the `19` major rows in `stan_case_studies` and `stan_tutorials` that are source-identical copies of `example_models` rows. Those duplicate rows are retained in `MODEL_LIST.md` for inventory completeness but are excluded here. No within-source variants were collapsed.

The review was manual and split by source family. The primary blocker table is non-overlapping and sums to `442`. Many models have secondary blockers as well, so the feature tiers should be read as "primary blocker resolved" counts, not as a guarantee that every model in that tier would need only one language change.

## Direct Answer

Among the `442` deduplicated major cases:

| Allowed change | Additional major models covered | Cumulative additional models |
|---|---:|---:|
| Add explicit priors or allow flat/improper/no-prior cases | 164 | 164 |
| Add a built-in finite mixture operator | 40 | 204 |
| Add other self-contained observation primitives similar to mixture | 109 | 313 |
| Add custom prior/process primitives as well | 43 | 356 |
| Add protected-data interface rewrites | 50 | 406 |
| Remaining other/out-of-scope cases | 36 | 442 |

So the main numbers are:

- Priors policy alone adds `164` models.
- Finite mixture support adds `40` models.
- Priors plus finite mixture adds `204` models.
- Priors plus finite mixture plus other self-contained observation primitives adds `313` models.
- If custom prior/process primitives are also considered reasonable SafeStan primitives, the count rises to `356`.

## Primary Blockers

| Primary blocker | Count | Representative models | What is missing |
|---|---:|---|---|
| Explicit flat/improper/no-prior parameter discipline | 164 | `example_models/arm-ch-5-wells-dae`, `example_models/knitr-chapter1-vector-regression`, `posteriordb/wells-data-wells-dae-model`, `betanalpha_knitr_case_studies/weakly-informative-shapes-regression-no-prior`, `stancon_talks/2018-helsinki-contributed-talks-modrak-genexpi-stan-stan-estimate-sigma-absolute` | A SafeStan policy for adding explicit priors, accepting intentional flat or improper priors, accepting bounded uniform priors as priors, and mechanically vectorizing priors over arrays/matrices without changing density. |
| Built-in finite mixture operator | 40 | `example_models/basic-estimators-normal-mixture-k`, `example_models/knitr-chapter2-mixture`, `forestdb/finite-gaussian-mixture`, `posteriordb/normal-2-normal-mixture`, `betanalpha_knitr_case_studies/identifying-mixture-models-gauss-mix` | A trusted finite-mixture observation primitive for normalized `log_mix`/`log_sum_exp` mixtures and closely related finite model-selection/changepoint mixtures. |
| Other self-contained protected-observation primitive | 109 | `example_models/bpa-ch-07-cjs-c-c`, `example_models/bpa-ch-12-nmix0`, `forestdb/hidden-markov-model`, `posteriordb/hmm-gaussian-simulated-hmm-gaussian`, `example_models/knitr-noisy-raters-dawid-skene-dawid-skene`, `example_models/basic-estimators-normal-censored` | Trusted observation primitives for HMM/forward algorithms, capture-recapture and occupancy/N-mixture likelihoods, LDA/topic and latent-class likelihoods, censoring/truncation/survival, Skellam/hurdle/GPD/race/LBA kernels, ordinal IRT kernels, Kronecker-GP observation likelihoods, and GARCH/time-series conditional likelihoods. |
| Custom prior/process primitive | 43 | `example_models/knitr-car-iar-poisson-bym2`, `example_models/jupyter-sum-to-zero-stan-bym2-soft`, `posteriordb/traffic-accident-nyc-bym2-offset-only`, `betanalpha_knitr_case_studies/brownian-bridge-stan-programs-brownian-bridge-prior-cp`, `stancon_talks/2018-helsinki-contributed-talks-laitinen-fixed-parameter-hierarchical-noncentered` | Trusted parameter-side primitives or certification for ICAR/CAR/BYM/GMRF priors, Brownian/OU/state-space processes, sum-to-zero and expression priors, IPM/state-process priors, determinant/P-spline penalties, triangular/custom shape priors, and user-defined prior densities. |
| Protected-data interface/layout rewrite | 50 | `bda_r_demos/demos-rstan-lin-std`, `example_models/applications-covid-19-imperial-model-imperial-model`, `example_models/arm-ch-4-logearn-height`, `example_models/bugs-examples-vol1-lsat-lsat`, `posteriordb/bones-data-bones-model`, `posteriordb/ecdc0501-covid19imperial-v3` | A disciplined data-interface rewrite mechanism for transformed, expanded, split, ragged, sliced, row-wise, missing-data, or otherwise non-top-level protected observations. |
| Other, not a reasonable primitive, or stress case | 36 | `forestdb/adjectives`, `forestdb/blm`, `forestdb/scalar-implicature`, `forestdb/social-meaning`, `posteriordb/diamonds-diamonds`, `example_models/regression-tests-mother` | These are mostly arbitrary procedural likelihood tables, nested pragmatics/RSA programs, likelihood gates such as `prior_only`, toy manual target densities, or compiler/regression stress programs rather than good SafeStan language-extension targets. |
| **Total** | **442** |  |  |

## Source-Family Breakdown

| Review partition | Major cases | Add priors | Finite mixture | Other observation primitives | Custom prior/process primitives | Data-interface rewrite | Other/out of scope |
|---|---:|---:|---:|---:|---:|---:|---:|
| `example_models` | 254 | 113 | 13 | 65 | 30 | 32 | 1 |
| `posteriordb` | 75 | 32 | 5 | 20 | 2 | 13 | 3 |
| `betanalpha_knitr_case_studies` | 37 | 12 | 13 | 2 | 8 | 0 | 2 |
| `forestdb`, `bda_r_demos`, `stancon_talks` | 76 | 7 | 9 | 22 | 3 | 5 | 30 |
| **Total** | **442** | **164** | **40** | **109** | **43** | **50** | **36** |

## Feature Tiers

These tiers are cumulative over primary blockers and assume the current minor-rewrite methodology remains acceptable: deterministic data augmentation, reshaping, vectorization, and reordering that preserves the normalized density.

The current deduplicated compatible count is `721 / 1163`: `315` as-is plus `406` minor. The table below shows how many of the `442` major cases each feature tier would add.

| Tier | Added SafeStan capability or policy | Newly resolved primary blockers | Cumulative resolved major cases | Dedup compatible total | Notes |
|---|---|---:|---:|---:|---|
| 1 | Parameter-prior policy: explicit priors, intentional flat/improper priors, bounded uniform priors, and matrix/array prior-vectorization | 164 | 164 | 885 / 1163 | This is still the largest single blocker. It covers many GLM, regression, IRT, and MLE-style examples whose protected likelihood is otherwise ordinary. |
| 2 | Built-in finite mixture operator | 40 | 204 | 925 / 1163 | This includes normal mixtures, soft clustering, finite changepoint/model-selection mixtures, and other normalized finite latent mixture patterns. |
| 3 | Other self-contained protected-observation primitives | 109 | 313 | 1034 / 1163 | Highest-value language work after priors plus mixtures. It covers HMMs, capture-recapture, occupancy/N-mixture, LDA/topic models, censoring/truncation/survival, Skellam/hurdle/GPD/race/LBA, ordinal IRT, Kronecker-GP observation likelihoods, and related normalized likelihood kernels. |
| 4 | Trusted custom prior/process primitives | 43 | 356 | 1077 / 1163 | This is not observation-side like finite mixtures, but it is still relatively self-contained for ICAR/CAR/BYM, Brownian/OU/state-space, sum-to-zero, IPM/state-process, determinant/P-spline, and shape-prior families. |
| 5 | Protected-data interface rewrite support | 50 | 406 | 1127 / 1163 | Covers models that observe transformed, expanded, split, ragged, sliced, row-wise, missing-data, or otherwise non-top-level data. |
| 6 | Exclude, separately classify, or manually certify other/stress cases | 36 | 442 | 1163 / 1163 | Mostly ForestDB pragmatics/RSA programs and a few likelihood gates, toy target densities, or compiler stress tests. These should not drive core SafeStan primitive design. |

## Practical Takeaways

- The deduplicated full dataset leaves `442` major cases, not `461`; the removed rows are exactly the borrowed case-study/tutorial duplicates of `example_models`.
- Prior policy is the largest single unlock: `164` models.
- A finite mixture operator is useful but smaller than the broad "custom likelihood" bucket suggested by the earlier coarse analysis: it covers `40` models by itself.
- Other self-contained observation primitives are the next major payoff: `109` more models. These are good candidates for SafeStan primitives because they are normalized likelihood patterns, not arbitrary target manipulation.
- Custom prior/process primitives add another `43` models, but they are conceptually separate from finite-mixture-style observation primitives.
- Data-interface rewrites are a distinct compatibility layer. They add `50` models, but they require protecting the right observed object when the original Stan program scores a transformed, ragged, split, or derived representation.
- The safe translations also need validation work. After manually repairing the `61` compile-failure targets, the latest combined smoke check leaves `38` safe models that still do not run: `7` compile-time SafeStan protected-data failures, `15` initialization failures, and `16` runtime exceptions. These are translation/runtime validation failures among as-is/minor cases, not `major` compatibility blockers.
