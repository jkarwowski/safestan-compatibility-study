# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y1`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level data variable `y1`, which is observed exactly once with a plain built-in sampling statement. `x1`, `x2`, and `N` are context inputs and are not protected.
