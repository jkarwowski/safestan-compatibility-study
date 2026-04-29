# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only data variable observed with a sampling statement is the top-level variable `y`, and it is scored exactly once with the built-in `normal_id_glm` distribution before any other use. The remaining data variables (`N`, `J`, `county`, `u`, and `x`) are context inputs used as sizes, indices, or predictors. Each parameter has exactly one built-in prior sampling statement before it is used in the likelihood.
