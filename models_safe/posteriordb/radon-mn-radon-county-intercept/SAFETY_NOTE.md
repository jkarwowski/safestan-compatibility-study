# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation inside the loop, `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)`, with a single built-in vectorized sampling statement, `log_radon ~ normal(mu, sigma_y)`. The linear predictor `mu` is still computed deterministically from parameters and context data before the observation statement. This preserves the same normal likelihood while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level sampling statement. No data fields were added or changed.
