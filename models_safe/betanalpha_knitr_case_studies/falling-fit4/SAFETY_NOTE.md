# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_t_calib`, `obs_t_fall`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: manually corrected on 2026-04-30. The indexed per-cell likelihood statements `obs_t_fall[n, h] ~ normal(...)` were replaced by a single valid vector observation. `obs_t_fall` is now the deterministic flattening of the original `N_drops` by `N_heights` array in nested-loop order: `(n = 1, h = 1:N_heights)`, then `(n = 2, h = 1:N_heights)`, and so on. The model computes the corresponding mean vector before `obs_t_fall ~ normal(mu_t_fall, sigma_t)`. `obs_t_calib` is represented as a vector with the same values. This preserves the same product normal likelihood while keeping the protected variables `obs_t_calib` and `obs_t_fall`.
