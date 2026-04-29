# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The Stan program does not score any top-level data variable with a sampling statement; `x0`, `N_grid`, and `x_grid` are context inputs used only for generated predictions.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. All parameters have exactly one built-in prior sampling statement in the model block, and there is no protected observation to schedule.
