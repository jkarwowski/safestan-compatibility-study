# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter prior statements so that `lambda` is sampled before it is used in the scale of the `theta_cp` prior. This preserves the same posterior density because it only changes the order of additive log-density terms. The protected observation `y` is a top-level data variable and is observed exactly once with a built-in `normal` sampling statement. No data changes were made.
