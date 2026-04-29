# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_flat` (a deterministic row-major flattening of the original observed `y`).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the indexed, looped observation statements `y[i] ~ bernoulli_logit(...)` with a single plain protected sampling statement `y_flat ~ bernoulli_logit(eta_flat)`. The new data field satisfies `y_flat[(i - 1) * J + j] = y[i, j]` for `i = 1..I`, `j = 1..J`; for the supplied data this is `[0, 0, 0, 1, 0, 1]`. All parameter priors are unchanged, and `eta_flat` is computed only after those priors.
