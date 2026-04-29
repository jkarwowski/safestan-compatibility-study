# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a1`, `sigma_a2`, and `sigma_y`. These parameters already had finite bounds `<lower=0, upper=100>` in the original model, so the added priors are the matching proper uniform priors on the existing constrained support and satisfy SafeStan's requirement that every parameter have exactly one built-in prior before use. The observation model `y ~ normal(y_hat, sigma_y)` is unchanged, and `N`, `county`, and `x` remain unprotected context inputs.
