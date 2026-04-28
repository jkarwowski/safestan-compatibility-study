# Major SafeStan Blocker Issues

This analysis covers the `24` models currently classified as `major` in `RESULTS.md`. Counts below are model counts. The primary blocker table is non-overlapping; the secondary issue table is overlapping because several models have more than one SafeStan obstacle.

## Primary Blockers

| Primary blocker | Count | Models | What is missing |
|---|---:|---|---|
| Implicit improper parameter priors | 12 | `golf-putting-logistic`, `worldcup-first-try`, `worldcup-fixed`, `worldcup-no-prior`, `worldcup-no-sqrt`, `worldcup-replication`, `negative-binomial2`, `normal-location`, `simple-regression`, `two-pl-regression-centered`, `two-pl-regression-noncentered`, `vector-regression` | A SafeStan-recognized explicit improper/flat prior primitive for parameters, or a policy decision that certain Stan implicit priors are allowed. |
| Marginalized finite mixtures | 5 | `dirichlet-multinomial-mixture`, `finite-gaussian-mixture`, `normal-mixture`, `k-component-normal-mixture`, `k-component-normal-mixture-simplex` | A finite-mixture likelihood primitive that is normalized and accepted as a protected observation statement. |
| General finite latent marginalization | 2 | `medical-diagnosis`, `model-selection` | A broader `sum_over_finite_latent` construct for finite latent variables whose likelihood contribution is a normalized marginal. |
| Censoring/truncation likelihoods plus improper priors | 2 | `censored-normal`, `truncated-normal` | Protected-data truncation/censoring primitives; both also need an explicit improper prior solution for `mu`. |
| Hidden Markov sequence marginalization | 1 | `hidden-markov-model` | An HMM/forward-algorithm primitive, or a sequence-specialized finite latent summation construct. |
| Custom ICAR prior / user-defined distribution | 1 | `bym2-spatial-poisson` | A built-in ICAR/CAR/GMRF prior primitive, or a way to certify a user-defined prior distribution and reject-free dimension checks. |
| Distribution stress-test / repeated protected scoring | 1 | `multivariate-normal` | This is less like a statistical model and more like a Stan distribution-shape stress test. It repeatedly scores `y`, indexed `y[1]`, and transformed copies `ry`, and also has implicit improper priors. |

## Overlapping Issues

| Issue | Count | Models |
|---|---:|---|
| Parameters rely on implicit improper priors | 15 | `golf-putting-logistic`, all 5 `worldcup-*` models, `censored-normal`, `multivariate-normal`, `negative-binomial2`, `normal-location`, `simple-regression`, `truncated-normal`, `two-pl-regression-centered`, `two-pl-regression-noncentered`, `vector-regression` |
| Manual likelihood scoring with `target +=`, `log_mix`, `log_sum_exp`, or direct `_lpdf`/`_lpmf` construction | 9 | `dirichlet-multinomial-mixture`, `finite-gaussian-mixture`, `hidden-markov-model`, `medical-diagnosis`, `model-selection`, `censored-normal`, `k-component-normal-mixture`, `k-component-normal-mixture-simplex`, `normal-mixture` |
| Marginalized finite latent structure | 8 | The 5 finite-mixture models, plus `medical-diagnosis`, `model-selection`, and `hidden-markov-model` |
| Protected response is transformed or not a plain top-level data observation | 7 | all 5 `worldcup-*` models, `normal-location`, `multivariate-normal` |
| Truncation/censoring of protected observations | 2 | `censored-normal`, `truncated-normal` |
| Custom/user-defined distribution or prior rejected by SafeStan | 1 | `bym2-spatial-poisson` |
| Multiple protected-data scoring statements or indexed protected-data LHS | 1 | `multivariate-normal` |

## Feature Tiers

These tiers are cumulative and assume the current minor-rewrite methodology is allowed: deterministic data augmentation, reshaping, vectorization, and reordering that preserves the density.

| Tier | Added SafeStan capability | Newly resolved | Cumulative resolved | Notes |
|---|---|---:|---:|---|
| 1 | Explicit improper/flat parameter prior primitive | 12 | 12 | This handles the simple regression-style models and the World Cup variants. World Cup and `normal-location` still need deterministic top-level data augmentation, but that is mechanical under the current methodology. |
| 2 | Finite mixture protected-likelihood primitive | 5 | 17 | Covers normal mixtures and the Dirichlet-multinomial mixture if the primitive supports the relevant built-in component distributions. |
| 3 | General finite-latent marginalization primitive | 2 | 19 | Covers one-shot finite latent variables such as disease/no-disease and model-selection indicators. |
| 4 | Truncation and censoring protected-likelihood primitives | 2 | 21 | These two also require Tier 1 because their `mu` parameters currently rely on implicit improper priors. |
| 5 | HMM/forward-algorithm primitive | 1 | 22 | A generic finite-latent primitive might cover this only if it supports sequential dynamic-programming structure without exposing arbitrary `target +=`. |
| 6 | Built-in ICAR/CAR/GMRF prior primitive | 1 | 23 | This is a parameter-prior issue, not a protected-data likelihood issue. |
| 7 | Decide how to handle distribution stress tests | 1 | 24 | `multivariate-normal` is mostly a stress-test program with repeated/contradictory likelihood statements. It may be better to replace it with a representative valid multivariate-normal model rather than add language support for this pattern. |

## Practical Takeaways

- The largest real blocker is not protected data syntax; it is SafeStan's requirement that every parameter have an explicit built-in prior. Supporting an explicit flat/improper prior statement would move roughly half of the current major set into minor/as-is territory.
- Finite mixtures are the next highest-value language feature. A narrow mixture primitive resolves 5 models; a broader finite-latent marginalization primitive resolves at least 2 more, and possibly more if it is expressive enough for HMMs.
- Truncation/censoring is a small but important separate feature. It should probably be a protected-observation primitive rather than expressed through `target += normal_lccdf(...)`.
- `bym2-spatial-poisson` is blocked by priors over latent spatial effects, not by the observation model. It needs built-in spatial priors or a trusted-prior mechanism.
- `multivariate-normal` should be treated separately from the rest of the corpus. It is not a normal applied-model blocker; it is a distribution API stress test that intentionally scores the same data in many incompatible ways.
