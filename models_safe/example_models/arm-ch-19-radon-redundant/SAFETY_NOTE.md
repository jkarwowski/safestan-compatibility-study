# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level variable `y`, and it is observed exactly once with a built-in `normal` distribution. All parameters have explicit built-in priors before their model-block use through the likelihood, and the remaining data variables (`J`, `N`, `county`) are context inputs.
