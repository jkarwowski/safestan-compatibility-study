# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The context data variables `I`, `J`, `N`, `ii`, and `jj` are used only as sizes, indices, or predictors. Each parameter has exactly one built-in prior before being used in the model block.
