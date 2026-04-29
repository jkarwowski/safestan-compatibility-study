# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation inside the loop (`target += normal_lpdf(log_radon[n] | mu[n], sigma_y)`) with a vectorized built-in sampling statement, `log_radon ~ normal(mu, sigma_y)`. The linear predictor `mu` is still computed deterministically from the same parameters and context data before the likelihood statement. No data values were changed or added.
