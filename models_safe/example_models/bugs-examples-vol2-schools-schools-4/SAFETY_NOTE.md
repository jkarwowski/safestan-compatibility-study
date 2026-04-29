# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved all parameter prior sampling statements before any model-block use of the corresponding parameters, including use through the transformed parameter `alpha`. Replaced `to_vector(z) ~ normal(0, 1)` with the equivalent top-level matrix sampling statement `z ~ normal(0, 1)` so the parameter prior targets the top-level parameter directly. No data changes were made; all other top-level data variables are context inputs/predictors.
