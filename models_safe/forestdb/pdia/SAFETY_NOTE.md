# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_sum_exp(...)` likelihood with deterministic mixture probabilities `y_prob` and one built-in `y ~ categorical(y_prob)` observation statement for the protected data. Vectorized the Dirichlet priors for `local_weight` and `atom` so each top-level parameter is sampled exactly once outside loops. No data fields were added or changed.
