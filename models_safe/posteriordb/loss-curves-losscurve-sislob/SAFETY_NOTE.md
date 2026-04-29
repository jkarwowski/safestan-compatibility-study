# SafeStan Safety Note

Compatibility: as-is.

Protected data: `loss`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `loss` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `loss ~ normal(...)`. All other top-level data variables are context inputs used as indices, predictors, constants, or configuration. Each parameter has exactly one built-in prior sampling statement before it is used in the likelihood.
