# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement. The remaining data variables (`M`, `N`, `x0`, and `X`) are context inputs used only for dimensions and predictors. Parameters `alpha` and `beta` each have one built-in prior before being used in the observation model.
