# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a built-in `normal` sampling statement. The predictors and dimensions (`X`, `N`, and `M`) are unprotected context data. Each parameter (`beta`, `alpha`, and `sigma`) has exactly one built-in prior before being used in the likelihood.
