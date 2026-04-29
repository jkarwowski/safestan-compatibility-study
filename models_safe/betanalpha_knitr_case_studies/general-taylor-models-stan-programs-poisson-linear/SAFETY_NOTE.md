# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, after the parameter priors for `alpha` and `beta`. Context data variables `M`, `N`, `x0`, and `X` are used only for sizes and predictors.
