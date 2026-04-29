# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The context inputs `N`, `M`, and `X` are not scored as observations. All parameters have exactly one built-in prior sampling statement before being used in the likelihood.
