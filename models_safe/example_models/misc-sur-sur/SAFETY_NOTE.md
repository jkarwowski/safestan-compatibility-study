# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter priors so that `beta`, `L_Omega`, and `L_sigma` are each sampled before any model-block use. Replaced `to_vector(beta) ~ normal(0, 5)` with the equivalent vectorized top-level parameter statement `beta ~ normal(0, 5)`, preserving the same product normal prior density while satisfying SafeStan's sampling-target discipline. No data changes were required.
