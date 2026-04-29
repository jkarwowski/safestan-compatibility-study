# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level vector `y`, which appears exactly once on the left side of a built-in `normal` likelihood after all parameters have received built-in priors. `N` and `w` are context data used as size/predictor inputs and are not protected.
