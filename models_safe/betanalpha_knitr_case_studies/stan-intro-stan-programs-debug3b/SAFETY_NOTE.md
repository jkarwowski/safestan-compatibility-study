# SafeStan Safety Note

Compatibility: as-is.

Protected data: none; the program has no top-level data variables and does not score any observed data.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `x ~ normal(mu, 1)` for the top-level parameter `x`, and there is no protected data interface for this model.
