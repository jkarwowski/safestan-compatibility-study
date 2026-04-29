# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The remaining data variables (`N`, `x0`, and `X`) are context inputs used only as sizes or predictors, and all parameters have one built-in prior before the observation model uses them through `mu`.
