# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The parameter `theta` has a built-in prior before it is used in the likelihood. Other data variables (`K`, `N`, `context_idx`, and `sigma`) are context inputs and are not protected.
