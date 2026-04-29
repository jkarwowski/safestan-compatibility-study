# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement. Context data variables `J`, `N`, and `county` are used only as sizes/indices/predictors. All parameters have explicit built-in prior sampling statements before the likelihood uses transformed quantities depending on them.
