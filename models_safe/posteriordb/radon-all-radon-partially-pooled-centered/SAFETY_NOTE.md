# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` likelihood loop with a single vectorized built-in sampling statement, `log_radon ~ normal(mu, sigma_y)`. The predictor vector `mu` is still computed deterministically from `alpha` and `county_idx` before observing `log_radon`. No data fields were added or changed; `N`, `J`, and `county_idx` remain context inputs.
