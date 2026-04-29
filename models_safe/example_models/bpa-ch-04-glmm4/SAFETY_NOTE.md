# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of indexed likelihood statements `obs[i] ~ poisson_log(...)` with one top-level protected-data sampling statement `obs ~ poisson_log(log_lambda_obs)`. The vector `log_lambda_obs` is a deterministic transformed-parameter gather of the same linear predictors used by the original likelihood. Added explicit `uniform(0, 5)` priors for `sd_alpha` and `sd_eps`, matching their finite declaration bounds and preserving the posterior up to a constant. The supplied data JSON was copied unchanged.
