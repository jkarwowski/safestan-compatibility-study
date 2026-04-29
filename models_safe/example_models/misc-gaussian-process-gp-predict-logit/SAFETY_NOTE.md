# SafeStan Safety Note

Compatibility: as-is.

Protected data: `z1`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `z1` is a top-level data variable and is scored exactly once by the built-in `bernoulli_logit` distribution with a plain sampling statement after all parameter priors. Other data variables (`N1`, `x1`, `N2`, `x2`) are context inputs and are not sampled as observations.
