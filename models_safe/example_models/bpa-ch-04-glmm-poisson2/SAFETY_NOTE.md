# SafeStan Safety Note

Compatibility: minor.

Protected data: `C_safestan_flat`, a deterministic row-major flattening of the original count array `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped likelihood statements `C[i] ~ poisson_log(log_lambda[i])` with one top-level protected sampling statement `C_safestan_flat ~ poisson_log(log_lambda_safestan_flat)`. The new data field is defined by `C_safestan_flat[(i - 1) * nsite + j] = C[i, j]` using one-based Stan indices. Reordered priors so hierarchical parameters are given priors before being used, and added explicit `uniform(0, 2)` and `uniform(0, 1)` priors for the bounded parameters `sd_alpha` and `sd_year`, matching their original implicit bounded-support priors.
