# SafeStan Safety Note

Compatibility: as-is.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `C` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `C ~ lognormal(...)`, after all parameters have received built-in priors. Other data variables are used only as context inputs for the ODE solution and prediction.
