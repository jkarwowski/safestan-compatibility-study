# SafeStan Safety Note

Compatibility: as-is.

Protected data: `n`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `n` is a top-level data variable and is scored exactly once with a plain built-in sampling statement (`n ~ binomial_logit(...)`). Other data variables (`I`, `N`, `x1`, `x2`) are context inputs used only as sizes, predictors, or trial counts. All parameters have built-in prior sampling statements before their later use in the likelihood.
