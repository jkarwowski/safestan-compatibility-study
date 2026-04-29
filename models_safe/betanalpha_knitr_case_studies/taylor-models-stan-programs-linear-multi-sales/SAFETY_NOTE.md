# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the protected observation already appears as the top-level sampling statement `y ~ normal(...)` and is not used before observation. The original program gave priors to `beta[1]`, `beta[2]`, and `beta[3]` using indexed left-hand sides; SafeStan requires one prior sampling statement on the top-level parameter. The safe model makes the model's hard-coded three-covariate slope-prior structure explicit by constraining `M` to 3 and replaces those three component priors with the equivalent vectorized prior `beta ~ normal(...)`. No data fields or values were added; `data_safe.json` is the supplied data unchanged.
