# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation inside the loop, `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)`, with the equivalent vectorized built-in sampling statement `log_radon ~ normal(mu, sigma_y)`. This preserves the same likelihood density while satisfying SafeStan's requirement that protected data be scored exactly once by a built-in distribution with a plain top-level left-hand side. The predictor `floor_measure` and size `N` remain unprotected context inputs. Parameter priors were already explicit and are unchanged. No data values were changed or added.
