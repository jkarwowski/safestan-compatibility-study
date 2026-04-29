# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the prior statement `to_vector(eta_a) ~ normal(0,1)` with `eta_a ~ normal(0,1)` so the sampling statement targets the top-level parameter identifier required by SafeStan. Stan's vectorized normal density over the matrix `eta_a` sums the same elementwise log densities as `to_vector(eta_a)`, so the posterior/log density is unchanged. No data changes were made; all other data are context inputs.
