# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y1`, `y2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data variables and each is observed exactly once with a plain built-in sampling statement. The covariates, sizes, and prediction grid are context inputs and are not protected.
