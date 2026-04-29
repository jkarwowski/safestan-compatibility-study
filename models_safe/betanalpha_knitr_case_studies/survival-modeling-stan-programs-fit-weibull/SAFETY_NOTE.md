# SafeStan Safety Note

Compatibility: as-is.

Protected data: `obs_times`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `obs_times` is a top-level data variable and is observed exactly once with the built-in `weibull` sampling statement after the parameter priors. The context input `N` is used only as a size.
