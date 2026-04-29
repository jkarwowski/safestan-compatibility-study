# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` inside the loop with a deterministic loop that computes `mu`, followed by one top-level built-in sampling statement `log_radon ~ normal(mu, sigma_y)`. This preserves the same normal likelihood density while satisfying SafeStan's requirement that the protected data variable be observed exactly once with a plain sampling statement. The data file is unchanged.
