# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual likelihood accumulation `target += normal_lpdf(log_radon[n] | mu[n], sigma_y)` inside the loop with a single built-in sampling statement `log_radon ~ normal(mu, sigma_y)` after the deterministic computation of `mu`. This preserves the same density because the vectorized normal likelihood is the sum of the elementwise normal log densities. No data fields were added or changed; `N`, `J`, `county_idx`, and `floor_measure` remain unprotected context inputs.
