# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that every parameter receives its built-in prior before any model-block use through `obs_mu` or transformed parameters. Replaced `to_vector(GP_region_std) ~ normal(0, 1)` and `to_vector(GP_state_std) ~ normal(0, 1)` with direct top-level matrix sampling statements; this preserves the same elementwise normal prior density while satisfying SafeStan's top-level parameter prior discipline. The protected observation `y` remains a top-level data variable and is scored exactly once with the built-in `normal` distribution. No data changes were required.
