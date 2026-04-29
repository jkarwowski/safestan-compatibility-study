# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with the built-in sampling statement `y ~ normal(mu, sigma);`. The remaining data variables (`M`, `N`, `x0`, and `X`) are context inputs. All parameters have exactly one built-in prior sampling statement before the observation model is evaluated.
