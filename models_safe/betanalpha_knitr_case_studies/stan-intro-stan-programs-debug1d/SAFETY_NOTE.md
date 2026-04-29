# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no top-level data variables and no observed likelihood terms; the only sampling statement is the built-in prior `x ~ normal(a * b, 1)` for the top-level parameter `x`.
