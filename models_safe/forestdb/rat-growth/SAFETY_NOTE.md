# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the nested indexed likelihood statements `y[n, t] ~ normal(...)` with a single vectorized built-in sampling statement `y_vec ~ normal(mu_y, sigma_y)`. The protected data are now `y_vec`, the row-major deterministic flattening of the original `matrix[N, T] y`, with `y_vec[(n - 1) * T + t] = y[n, t]`. The local vector `mu_y` is computed after all parameter priors in the model block. This preserves the original product of normal likelihood terms while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level left-hand side and not inside loops.

The data file was changed only by replacing `y` with its deterministic row-major flattening `y_vec`.
