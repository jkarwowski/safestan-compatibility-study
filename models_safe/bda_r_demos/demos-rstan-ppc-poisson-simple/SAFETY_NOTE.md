# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with the built-in `poisson` distribution after the parameter `lambda` has its built-in prior. The size `N` is context data and is not protected.
