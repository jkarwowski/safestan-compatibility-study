# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that all parameter priors occur before any model-block use of parameters or transformed parameters derived from them. Replaced `to_vector(GP_region_std) ~ normal(0, 1)` and `to_vector(GP_state_std) ~ normal(0, 1)` with elementwise matrix sampling statements `GP_region_std ~ normal(0, 1)` and `GP_state_std ~ normal(0, 1)`, preserving the same product normal density while making the sampling targets top-level parameter identifiers. The protected observation `y` remains a top-level data variable and is scored exactly once by the built-in `normal` distribution. No data changes were required.
