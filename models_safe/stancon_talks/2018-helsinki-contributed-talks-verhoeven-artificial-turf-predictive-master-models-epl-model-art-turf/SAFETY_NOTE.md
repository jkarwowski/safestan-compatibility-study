# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the prior `to_vector(eta_a) ~ normal(0,1)` as `eta_a ~ normal(0,1)`. This is the same elementwise normal prior density, but uses the top-level parameter identifier required by SafeStan sampling discipline. No data changes were required. The protected observation `goal_difference` is scored exactly once with a built-in distribution and a plain top-level sampling statement.
