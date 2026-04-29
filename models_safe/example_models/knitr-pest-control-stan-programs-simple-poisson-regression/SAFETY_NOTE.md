# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `complaints` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `complaints ~ poisson_log(...)`, after both parameters have received their priors. `N` and `traps` are context inputs used only as size/predictor data.
