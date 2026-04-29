# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the prior for `tau_day` before the prior for `delta_days_cp`, because `delta_days_cp ~ double_exponential(0, tau_day)` uses `tau_day` as its scale. This is only a reordering of commuting log-density terms and preserves the original posterior/log density. No data fields were added or changed.
