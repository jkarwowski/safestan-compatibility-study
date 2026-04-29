# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_sample`, `y_spec`, `y_sens`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 1)` priors for the bounded parameters `p`, `spec`, and `sens` before their first use in the model block. These priors are density-neutral relative to the original finite `[0, 1]` parameter constraints. The observed/protected variables are each scored exactly once by built-in `binomial` sampling statements. No data changes were made; `n_sample`, `n_spec`, and `n_sens` remain unprotected context counts.
