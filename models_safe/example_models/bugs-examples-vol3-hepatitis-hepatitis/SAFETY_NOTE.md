# SafeStan Safety Note

Compatibility: minor.

Protected data: `Yvec1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that every parameter prior is applied before any model-block use of that parameter, including uses through transformed parameters such as `sigma_y`, `sigma_alpha`, and `sigma_beta`. The protected observation `Yvec1` remains a top-level data variable and is observed exactly once with the built-in `normal` distribution. No data changes were made.
