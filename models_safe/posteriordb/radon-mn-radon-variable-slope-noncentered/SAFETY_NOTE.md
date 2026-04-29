# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped manual likelihood contribution `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with the equivalent vectorized built-in sampling statement `log_radon ~ normal(mu, sigma_y)`. This preserves the same log density while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level sampling statement. No data changes were made.
