# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` inside the loop with a single built-in vectorized sampling statement `log_radon ~ normal(mu, sigma_y)`. The linear predictor `mu` is still computed deterministically before the observation statement. No data fields were changed or added.
