# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no data block and does not score any observed data; the only sampling statement is the built-in prior `x ~ cauchy(0, 1)` for the top-level parameter `x`.
