# SafeStan Safety Note

Compatibility: as-is.

Protected data: `x1`, `y1`, `x2`, `y2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data variables and each is observed exactly once with a plain built-in sampling statement in the model block. The remaining data variables (`N1`, `N2`, `N_grid`, and `x_grid`) are context inputs and are not protected.
