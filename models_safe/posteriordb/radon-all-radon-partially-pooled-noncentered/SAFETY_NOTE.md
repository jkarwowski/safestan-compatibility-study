# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation inside the loop, `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)`, with a single vectorized built-in sampling statement, `log_radon ~ normal(mu, sigma_y)`. The predictor vector `mu` is still computed deterministically from `county_idx` and `alpha` before observing `log_radon`. No data fields were added or changed.
