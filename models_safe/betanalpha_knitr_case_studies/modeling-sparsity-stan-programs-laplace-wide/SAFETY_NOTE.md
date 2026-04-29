# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, after the parameter `theta` has received its built-in prior. Other data variables (`K`, `N`, `context_idx`, and `sigma`) are context inputs used only as sizes, indices, or predictors/constants.
