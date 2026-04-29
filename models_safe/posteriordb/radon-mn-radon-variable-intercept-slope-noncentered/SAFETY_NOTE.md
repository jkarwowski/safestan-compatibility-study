# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped manual likelihood contribution `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with a single built-in vectorized sampling statement `log_radon ~ normal(mu, sigma_y)`. The predictor vector `mu` is computed deterministically from context data and already-prior-sampled parameters before this observation statement. This preserves the same normal likelihood density while satisfying SafeStan's requirement that the protected observation be scored exactly once by a built-in distribution with a plain top-level data variable on the left-hand side. No data fields were added or changed.
