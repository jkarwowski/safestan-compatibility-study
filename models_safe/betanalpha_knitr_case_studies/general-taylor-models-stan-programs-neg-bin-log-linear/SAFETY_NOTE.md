# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with the built-in `neg_binomial_2_log` distribution using a plain sampling statement. The other data variables (`M`, `N`, `x0`, and `X`) are context inputs used only for dimensions and predictors. Each parameter (`alpha`, `beta`, and `inv_phi`) has exactly one built-in prior sampling statement before the observation model uses it.
