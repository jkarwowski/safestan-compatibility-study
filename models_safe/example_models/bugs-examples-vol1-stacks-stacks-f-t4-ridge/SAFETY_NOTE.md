# SafeStan Safety Note

Compatibility: as-is.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `Y` is the only top-level data variable observed with a sampling statement, and it is scored exactly once as a plain identifier using the built-in `student_t` distribution. The other data variables (`N`, `p`, and `x`) are context inputs used for dimensions and predictors. All parameters have exactly one built-in prior before their model-block use.
