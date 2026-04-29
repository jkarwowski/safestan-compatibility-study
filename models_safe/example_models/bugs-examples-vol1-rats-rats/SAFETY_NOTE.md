# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the nested scalar likelihood statements `y[n, t] ~ normal(...)` with a single top-level vectorized observation `y ~ normal(y_hat, sigma_y)`. The helper array `y_hat` is filled in the model block after all parameter priors, so the protected data variable `y` is observed exactly once with a plain sampling statement. No data fields were added; `data_safe.json` is the supplied data unchanged.
