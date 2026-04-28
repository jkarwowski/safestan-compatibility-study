# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with the built-in sampling statement `y ~ normal(X * beta, sigma);` after the parameters `beta` and `sigma` have each received their prior sampling statements.
