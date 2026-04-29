# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a` and `sigma_y`, matching their finite parameter bounds, so every parameter has exactly one SafeStan prior before use. No data changes were made. The protected observation `y` remains a top-level data variable and is observed exactly once with `y ~ normal(y_hat, sigma_y)`. The other data variables (`N`, `n_pair`, `pair`, `pre_test`, and `treatment`) are context inputs.
