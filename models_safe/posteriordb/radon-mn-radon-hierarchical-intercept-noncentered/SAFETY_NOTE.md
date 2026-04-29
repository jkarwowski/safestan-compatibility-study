# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` inside the loop with the equivalent vectorized built-in sampling statement `log_radon ~ normal(mu, sigma_y)` after `mu` is computed. This preserves the same log density while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level sampling statement. The data file is unchanged.
