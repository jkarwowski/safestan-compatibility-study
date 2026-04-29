# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the indexed likelihood loop `obs[i] ~ poisson_log(...)` was replaced by a deterministic model-local vector `log_lambda_obs` followed by a single plain top-level protected observation statement `obs ~ poisson_log(log_lambda_obs)`. This preserves the same product Poisson-log likelihood while satisfying SafeStan's requirement that protected data be observed exactly once outside loops. Explicit `uniform(0, 5)` and `uniform(0, 3)` priors were added for `sd_alpha` and `sd_eps`, respectively, matching their finite bounded supports and replacing the original implicit uniform priors. The prior order was chosen so parameters are not used before their own prior statements. No data fields were added or changed.
