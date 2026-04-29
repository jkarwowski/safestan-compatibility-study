# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_flat`, a deterministic row-major flattening of the original observed array `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_flat` with deterministic relation `y_flat[(j - 1) * n_trials + t] = y[j, t]` for Stan indices `j = 1..n_dogs`, `t = 1..n_trials`. The original `y` remains as context for the deterministic history arrays `prev_shock` and `prev_avoid`. Moved all parameter priors before parameter-dependent likelihood computations, changed `to_vector(z) ~ normal(0, 1)` to the equivalent elementwise prior `z ~ normal(0, 1)`, and replaced the nested indexed Bernoulli observations with one vectorized protected observation statement `y_flat ~ bernoulli(p_flat)` outside loops.
