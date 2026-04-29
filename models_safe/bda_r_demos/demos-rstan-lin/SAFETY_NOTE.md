# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with the plain built-in sampling statement `y ~ normal(mu, sigma);`. The other data variables are context inputs, and all parameters have built-in prior sampling statements before their use in the likelihood.
