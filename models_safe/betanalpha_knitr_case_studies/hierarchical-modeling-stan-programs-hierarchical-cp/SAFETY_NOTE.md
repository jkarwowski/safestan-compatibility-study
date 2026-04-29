# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ normal(theta[indiv_idx], sigma)`, after all parameters have received built-in priors. The remaining data variables (`N`, `K`, `sigma`, and `indiv_idx`) are context inputs and are not scored as observations.
