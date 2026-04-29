# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level data variable `y`, which appears exactly once on the left side of a built-in `normal` likelihood. All parameters have exactly one built-in prior sampling statement before they are used in the model likelihood, and the remaining data variables are context inputs used only as sizes, indices, or predictors.
