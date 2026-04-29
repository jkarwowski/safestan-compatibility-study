# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a` and `sigma_y`, which are already finite-bounded parameters and therefore have the same implicit uniform support in the original model. The `sigma_a` prior is placed before `sigma_a_hat` is used in the prior for `a`, and the `sigma_y` prior is placed before `sigma_y_hat` is used in the likelihood for `y`. No data changes were required; all other data variables are context inputs used as sizes, indices, or predictors.
