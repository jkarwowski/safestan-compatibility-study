# SafeStan Safety Note

Compatibility: minor.

Protected data: `marr_j`, `marr_a`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 1)` priors for `mean_sj`, `mean_sa`, `mean_rj`, and `mean_ra`; these match the implicit uniform densities from their finite `[0, 1]` constraints and do not change the posterior density. Replaced the row-wise multinomial likelihood loop with vectorized built-in multinomial sampling statements, so each protected top-level data variable is observed exactly once with a plain left-hand-side identifier and outside any loop. `data_safe.json` is unchanged from the supplied data.
