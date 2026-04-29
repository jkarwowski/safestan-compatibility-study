# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `complaints` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `complaints ~ poisson_log(...)`. The other data variables (`N`, `traps`, `live_in_super`, and `log_sq_foot`) are context inputs used as sizes or predictors. All parameters have exactly one built-in prior before being used in the model block.
