# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual per-observation likelihood contribution `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` with a deterministic construction of `mu` followed by one vectorized built-in sampling statement, `log_radon ~ normal(mu, sigma_y)`. This preserves the same likelihood density. The predictors and indexing data (`floor_measure`, `county_idx`, `J`, and `N`) remain unprotected context inputs. No data changes were required.
