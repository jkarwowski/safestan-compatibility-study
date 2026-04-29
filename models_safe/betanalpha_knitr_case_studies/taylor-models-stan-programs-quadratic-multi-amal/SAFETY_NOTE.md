# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic construction of the local coefficient vector `beta` until after all parameter prior sampling statements in the `model` block. In the original program, `beta0`, `beta1`, `beta2_d`, and `beta2_o` were used to construct `beta` before their priors, which violates SafeStan's parameter-use discipline. The observation model `y ~ normal(deltaX * beta, sigma)` is unchanged and `y` remains the single protected top-level data variable. No data changes were required.
