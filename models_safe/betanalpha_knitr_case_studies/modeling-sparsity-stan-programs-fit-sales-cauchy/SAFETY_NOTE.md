# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `tau_day` prior to occur before `tau_day` is used as the scale in the `delta_days_cp ~ cauchy(0, tau_day)` prior. This is a same-density mechanical change because Stan sampling statements add log-density terms and their order does not affect the posterior density. No data changes were made.
