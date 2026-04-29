# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the existing elementwise normal priors for `alpha` and `beta` before any model-block use of those parameters, and wrote them on the top-level parameter identifiers (`alpha ~ normal(0, 2)` and `beta ~ normal(0, 2)`) instead of `to_vector(...)`; this is the same vectorized normal density over all matrix entries. Replaced the loop of indexed observations `y[n] ~ categorical_logit(...)` with a single protected-data sampling statement `y ~ categorical_logit(v)` by constructing an array of category-logit vectors. The supplied data are unchanged.
