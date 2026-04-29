# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Protected data choice: `y` is the only top-level data variable scored by a sampling statement (`y ~ normal(y_hat, sigma_y)`). The remaining data variables are context inputs used for sizes and indexing.

Changes: added explicit built-in `uniform(0, 100)` priors for `sigma_a`, `sigma_b`, and `sigma_y`, matching their finite parameter constraints. This satisfies SafeStan's unique-prior requirement for all parameters without changing the intended posterior. No data fields were added or reshaped.
