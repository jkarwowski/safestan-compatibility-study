# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ binomial_logit(...)`, after all parameters used by that likelihood have received their priors. The remaining data variables are context inputs.
