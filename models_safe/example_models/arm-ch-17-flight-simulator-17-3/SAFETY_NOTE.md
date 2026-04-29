# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only data variable scored by a sampling statement is the top-level observation `y`, which is observed exactly once with `y ~ normal(y_hat, sigma)` after all parameters have received built-in priors. Other data variables (`N`, `n_treatment`, `n_airport`, `treatment`, and `airport`) are context inputs used as sizes and indices, not protected observations.
