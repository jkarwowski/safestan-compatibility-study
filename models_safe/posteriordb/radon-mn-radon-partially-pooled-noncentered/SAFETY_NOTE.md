# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual per-observation likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with a single built-in vectorized sampling statement `log_radon ~ normal(mu, sigma_y)`. The linear predictor `mu` is still computed deterministically from `alpha` and `county_idx`. Existing parameter priors were already explicit built-in sampling statements and were left unchanged. No data fields were added or changed.
