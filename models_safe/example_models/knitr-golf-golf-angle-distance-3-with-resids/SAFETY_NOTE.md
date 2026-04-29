# SafeStan Safety Note

Compatibility: minor.

Protected data: `raw_proportion`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the likelihood left-hand side from a transformed-data variable to a top-level protected data variable `raw_proportion`. In `data_safe.json`, `raw_proportion[j]` is deterministically computed from the supplied data as `y[j] / n[j]`, matching the original transformed-data definition. The original `y` and `n` inputs are retained as context data. The vectorized prior `[sigma_angle, sigma_distance, sigma_y] ~ normal(0, 1)` was split into one built-in prior sampling statement per top-level parameter and placed before the likelihood, so each parameter is observed by its prior before being used in the model block. No likelihood or posterior density change was made.
