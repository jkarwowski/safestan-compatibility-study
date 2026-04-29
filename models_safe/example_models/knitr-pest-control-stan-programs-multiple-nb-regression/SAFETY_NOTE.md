# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `complaints` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The other data variables are context inputs used as predictors or sizes. All parameters have built-in prior sampling statements before they are used in the model likelihood.
