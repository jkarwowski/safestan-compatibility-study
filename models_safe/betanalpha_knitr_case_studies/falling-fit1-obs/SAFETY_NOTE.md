# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_t_fall_flat` (a deterministic flattening of the original `obs_t_fall` observation).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop-indexed observation statements `obs_t_fall[n, h] ~ normal(...)` with one vectorized sampling statement on the top-level protected variable `obs_t_fall_flat`. The safe data field is defined by `obs_t_fall_flat[(n - 1) * N_heights + h] = obs_t_fall[n][h]` for the supplied JSON values, matching the original nested-loop order. The local mean array is filled in the same order before the single observation statement. Priors on `sigma_t` and `g` were unchanged.
