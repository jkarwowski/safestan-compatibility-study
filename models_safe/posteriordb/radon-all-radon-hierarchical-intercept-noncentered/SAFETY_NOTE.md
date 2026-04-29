# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual looped likelihood contribution `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with the equivalent built-in sampling statement `log_radon ~ normal(mu, sigma_y)` after `mu` is computed. No data fields were added or changed. Predictor and indexing data (`J`, `N`, `county_idx`, `log_uppm`, and `floor_measure`) remain unprotected context inputs.
