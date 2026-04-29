# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual per-observation likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with the equivalent built-in vectorized sampling statement `log_radon ~ normal(mu, sigma_y)`. This preserves the same log likelihood while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level sampling statement. The data file is unchanged.
