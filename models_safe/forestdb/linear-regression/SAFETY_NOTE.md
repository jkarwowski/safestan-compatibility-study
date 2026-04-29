# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The response `y` is a top-level data variable observed exactly once with a built-in `normal` sampling statement, after the parameters `beta` and `sigma` receive their built-in priors. The remaining data variables `N`, `K`, and `X` are context inputs and are not protected.
