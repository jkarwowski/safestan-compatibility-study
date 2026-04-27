# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The observed data `y` is a top-level data variable and is scored by a plain vectorized sampling statement, `y ~ normal(mu, sigma)`. The parameters have explicit proper priors before the likelihood, and the model does not use manual `target +=` scoring, direct `_lpdf` calls, or protected-data transformations before observation.
