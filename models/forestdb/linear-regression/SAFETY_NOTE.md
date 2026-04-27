# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; `y` is a top-level data variable observed by a plain vectorized `y ~ normal(X * beta, sigma)` sampling statement, and the parameters have explicit proper priors before the likelihood.
