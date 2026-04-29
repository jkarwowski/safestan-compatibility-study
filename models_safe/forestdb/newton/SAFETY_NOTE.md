# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. Context data `N`, `K`, and `X` are not protected. Parameters `beta` and `sigma` each have one built-in prior before being used in the likelihood.
