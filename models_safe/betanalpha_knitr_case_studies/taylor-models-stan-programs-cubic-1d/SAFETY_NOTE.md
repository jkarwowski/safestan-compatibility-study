# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement. All parameters have built-in prior sampling statements before they are used in the likelihood, and the remaining data variables are context inputs.
