# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y_obs` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The parameter `f_predict` has exactly one built-in prior sampling statement before it is used in the model likelihood. Other data variables are context inputs used only as predictors, indices, constants, or transformed-data configuration.
