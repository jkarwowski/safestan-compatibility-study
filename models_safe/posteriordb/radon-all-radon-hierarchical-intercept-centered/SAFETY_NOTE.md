# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` inside the loop with a single vectorized built-in sampling statement `log_radon ~ normal(mu, sigma_y)` after `mu` is computed. This is a same-density rewrite because Stan's vectorized normal likelihood sums the elementwise normal log densities. All parameter priors were already explicit and occur before parameter use. No data changes were required.
