# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level data variable `y`, and it is observed exactly once with the built-in `normal` distribution after all parameter priors. `J` and `sigma` are context data used as size/configuration and known standard errors, respectively.
