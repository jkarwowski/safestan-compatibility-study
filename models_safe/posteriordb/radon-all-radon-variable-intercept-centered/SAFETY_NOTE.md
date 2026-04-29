# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual looped likelihood contribution `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with the equivalent built-in vectorized sampling statement `log_radon ~ normal(mu, sigma_y)`. This preserves the same likelihood density while satisfying SafeStan's requirement that protected observations be scored exactly once by a built-in distribution with a plain top-level left-hand side. No data changes were required.
