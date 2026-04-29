# SafeStan Safety Note

Compatibility: as-is.

Protected data: `n`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `n` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `n ~ binomial_logit(...)`. Other data variables (`I`, `N`, `x1`, `x2`) are context inputs used as sizes, predictors, or constants and are not protected. Each parameter has exactly one built-in prior before it is used in the model block.
