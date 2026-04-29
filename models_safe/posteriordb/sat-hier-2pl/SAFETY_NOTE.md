# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: `data_safe.json` is unchanged. The protected observation model remains `y ~ bernoulli_logit(...)`, with `I`, `J`, `N`, `ii`, and `jj` treated as context inputs. The manual `target += multi_normal_cholesky_lpdf(...)` loop for the item-parameter prior was replaced by the equivalent vectorized built-in sampling statement `xi ~ multi_normal_cholesky(mu, L_Sigma)`. To make that possible, the original `xi1`/`xi2` parameter vectors were represented as a single top-level `array[I] vector[2] xi` parameter, which is a unit-Jacobian deterministic reshape/permutation; `xi1` and `xi2` are retained as transformed-parameter copies. Componentwise priors for `mu` and `tau` were vectorized so each top-level parameter has one prior statement, and priors were ordered before dependent computations.
