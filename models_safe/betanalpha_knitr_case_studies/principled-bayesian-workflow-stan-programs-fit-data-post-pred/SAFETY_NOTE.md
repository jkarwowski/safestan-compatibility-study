# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement, `y ~ poisson(lambda)`, after the parameter `lambda` has received its built-in prior, `lambda ~ normal(0, 6)`. The context input `N` is used only for sizing.
