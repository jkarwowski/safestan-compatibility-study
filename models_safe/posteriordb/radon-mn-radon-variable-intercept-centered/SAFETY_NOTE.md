# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual looped likelihood contribution `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with the equivalent vectorized built-in sampling statement `log_radon ~ normal(mu, sigma_y)`. This preserves the same log density because Stan's vectorized normal likelihood is the sum of the elementwise normal log densities. No data values were changed.
