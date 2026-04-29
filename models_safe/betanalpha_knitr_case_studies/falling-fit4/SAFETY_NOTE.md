# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_t_calib`, `obs_t_fall`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the indexed per-cell likelihood statements `obs_t_fall[n, h] ~ normal(...)` were moved out of the nested loops. The rewritten model first computes the same array of means `mu_t_fall` and then observes the top-level protected variable `obs_t_fall` exactly once with a built-in `normal` sampling statement. This preserves the same product normal likelihood. `data_safe.json` is unchanged; `N_calibrations`, `N_heights`, `N_drops`, `heights`, and `m` remain context inputs.
