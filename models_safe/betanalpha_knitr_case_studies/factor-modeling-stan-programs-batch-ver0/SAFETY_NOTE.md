# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ poisson_log(...)`, after the parameter `baseline` has received its built-in prior. Other data variables are context inputs used as predictors, sizes, or indices and are not protected.
