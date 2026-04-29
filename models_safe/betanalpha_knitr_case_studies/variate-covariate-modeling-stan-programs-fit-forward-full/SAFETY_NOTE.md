# SafeStan Safety Note

Compatibility: as-is.

Protected data: `x1`, `y1`, and `x2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. Each protected observation is a top-level data variable and is observed exactly once with a plain built-in sampling statement. Parameter priors are built-in sampling statements and occur before parameter use. The context input `N` is not protected.
