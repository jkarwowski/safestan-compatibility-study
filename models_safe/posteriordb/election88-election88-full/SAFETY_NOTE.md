# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: kept the data unchanged. Added explicit `uniform(0, 100)` prior sampling statements for `sigma_a`, `sigma_b`, `sigma_c`, `sigma_d`, and `sigma_e` before they are used as scale parameters. These finite-interval uniform priors make the original bounded flat hyperpriors explicit, preserving the posterior up to the corresponding normalizing constants, and satisfy SafeStan's requirement that every parameter have exactly one prior before use. The protected response `y` remains a top-level data variable and is observed exactly once with `y ~ bernoulli_logit(y_hat)` after all parameter priors.
