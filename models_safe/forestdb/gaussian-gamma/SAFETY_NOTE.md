# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement (`y ~ normal(mu, sigma)`) before any other use. Both parameters have exactly one built-in prior sampling statement before subsequent model-block use (`tau ~ gamma(...)`, then `mu ~ normal(...)`).
