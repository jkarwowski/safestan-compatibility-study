# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan_flat`, a deterministic row-major flattening of the original observed array `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_flat` with deterministic relation `y_safestan_flat[(i - 1) * n_trials + j] = y[i, j]` for 1-based Stan indices. The original `y` is retained as context to reproduce the lagged `n_avoid` and `n_shock` predictors without reading protected data before observation. The elementwise likelihood loop was replaced by one vectorized Bernoulli sampling statement on the protected top-level data variable. The two indexed beta priors were replaced by the equivalent single top-level vectorized prior `beta ~ uniform(beta_lower, beta_upper)`.
