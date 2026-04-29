# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`, `z`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the `y` likelihood by first computing the same per-observation Poisson-log linear predictor in a local vector `eta_y`, then observing the top-level protected variable with `y ~ poisson_log(eta_y)`. This removes the indexed protected left-hand side and the observation sampling statement from the loop without changing the density. The `z` likelihood was already a top-level built-in sampling statement. No data values were changed.
