# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_t_calib`, `obs_t_fall`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the elementwise `obs_t_fall[n, h] ~ normal(...)` likelihood inside nested loops was replaced by a single vectorized sampling statement on the top-level protected variable `obs_t_fall`. In `data_safe.json`, `obs_t_fall` is the deterministic flattening of the original `N_drops` by `N_heights` array in the same nested-loop order: `(n = 1, h = 1:N_heights)`, then `(n = 2, h = 1:N_heights)`, and so on. The model computes the corresponding mean vector after all parameter priors and before the observation statement. The calibration observations `obs_t_calib` are represented as a vector with the same values. These changes preserve the original product normal likelihood while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level sampling statement.
