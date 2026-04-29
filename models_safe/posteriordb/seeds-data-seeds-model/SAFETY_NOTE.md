# SafeStan Safety Note

Compatibility: as-is.

Protected data: `n`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `n` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `n ~ binomial_logit(...)`, after all parameters used by the likelihood have received built-in priors. The remaining data variables (`I`, `N`, `x1`, and `x2`) are context inputs used as sizes, trial counts, and predictors, and are not protected.
