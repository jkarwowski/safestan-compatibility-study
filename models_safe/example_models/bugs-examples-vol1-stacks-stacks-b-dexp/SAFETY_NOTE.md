# SafeStan Safety Note

Compatibility: as-is.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `Y` is the only top-level data variable scored by a sampling statement, it is observed exactly once with the built-in `double_exponential` distribution using a plain top-level left-hand side, and it is not read before that observation. The other data variables (`N`, `p`, and `x`) are context inputs used for sizes and predictors. Each parameter has exactly one built-in prior sampling statement before it is used in the model likelihood.
