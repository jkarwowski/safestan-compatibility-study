# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter `beta0` receives its built-in prior before it is used in the protected-data likelihood. The likelihood `y ~ poisson_log(log_E + beta0)` and the prior `beta0 ~ normal(0.0, 2.5)` are otherwise unchanged, so the posterior density is preserved. No data changes were required.
