# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement, `y ~ normal(mu, sigma)`, after both parameters have their built-in priors. The remaining data variables (`N`, `mu0`, `lambda0`, `alpha0`, `beta0`) are context inputs used as sizes or hyperparameters and are not protected.
