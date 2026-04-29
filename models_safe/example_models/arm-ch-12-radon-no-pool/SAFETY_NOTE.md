# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with the built-in `normal_id_glm` sampling statement after all parameters have received built-in priors. Other data variables (`N`, `J`, `county`, and `x`) are context inputs only.
