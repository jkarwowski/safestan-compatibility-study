# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no observed data likelihood: all top-level data variables (`x0`, `N_grid`, and `x_grid`) are context inputs used only in generated quantities, and every parameter has exactly one built-in prior sampling statement before any use.
