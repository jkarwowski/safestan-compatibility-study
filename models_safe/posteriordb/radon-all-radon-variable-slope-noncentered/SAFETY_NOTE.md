# SafeStan Safety Note

Compatibility: minor.

Protected data: `log_radon`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual per-observation `target += normal_lpdf(...)` likelihood loop with a single built-in vectorized sampling statement, `log_radon ~ normal(mu, sigma_y);`, where `mu` is computed deterministically before the observation is scored. No data fields were added or changed. All parameters retain their original built-in prior sampling statements before they are used in the model likelihood.
