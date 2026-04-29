# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` inside the loop with a single built-in sampling statement `log_radon ~ normal(mu, sigma_y)`. The loop is retained only to compute the deterministic mean vector `mu` before the protected observation is scored. This is a same-density mechanical rewrite of the Normal likelihood into SafeStan-compatible form. The input data are unchanged.
