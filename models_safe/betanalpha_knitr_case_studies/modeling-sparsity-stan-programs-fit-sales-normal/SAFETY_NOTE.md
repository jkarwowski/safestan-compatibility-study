# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `tau_day` prior so that `tau_day` is sampled before it is used as the scale in the `delta_days_cp` prior. This is a same-density change because the affected prior factors are multiplied in the same joint density. No data changes were made.
