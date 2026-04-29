# SafeStan Safety Note

Compatibility: as-is.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `Y` is a top-level data variable and is observed exactly once with the built-in sampling statement `Y ~ normal(mu, sigma);`. The predictors and configuration inputs `N`, `p`, and `x` are context data only. All parameters (`beta0`, `beta`, and `sigmasq`) have exactly one built-in prior sampling statement before their transformed-parameter dependencies are used in the likelihood.
