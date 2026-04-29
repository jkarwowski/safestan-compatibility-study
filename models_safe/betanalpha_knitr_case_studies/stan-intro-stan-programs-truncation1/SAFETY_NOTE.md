# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The model has no data block and no observed data likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the two manual `target += normal_lpdf(...)` prior contributions with equivalent built-in Stan sampling statements for the top-level parameters `a` and `x`. No data changes were required.
