# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped manual likelihood contribution `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with a single vectorized built-in sampling statement, `log_radon ~ normal(mu, sigma_y)`. This preserves the normal observation model while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level sampling statement. The existing parameter priors were already built-in sampling statements before parameter use. No data changes were required.
