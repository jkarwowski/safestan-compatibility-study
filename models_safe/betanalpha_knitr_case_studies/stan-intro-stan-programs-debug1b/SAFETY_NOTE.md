# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The model has no top-level data variables and no observed data likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `x ~ normal(a * b, 1)` for the top-level parameter `x`, and it occurs before any model-block use of `x`.
