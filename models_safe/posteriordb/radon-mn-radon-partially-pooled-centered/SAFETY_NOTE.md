# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` inside the loop with a single built-in sampling statement `log_radon ~ normal(mu, sigma_y);` after constructing the deterministic predictor vector `mu`. This preserves the normal likelihood while satisfying SafeStan's requirement that the protected top-level data variable be observed exactly once with a plain sampling statement. The priors are unchanged and appear before the corresponding parameters are used. `N`, `J`, and `county_idx` remain unprotected context inputs. No data fields were added or changed.
