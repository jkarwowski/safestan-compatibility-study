# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The model does not observe or score any top-level data variable; `x0`, `N_grid`, and `x_grid` are context inputs used only for generated quantities.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. All parameters have exactly one built-in prior sampling statement in the model block, and there are no protected observations or arbitrary `target +=` likelihood terms.
