# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `complaints` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. All other data variables are context inputs, and all parameters have built-in prior sampling statements before the protected likelihood uses their dependent transformed quantities.
