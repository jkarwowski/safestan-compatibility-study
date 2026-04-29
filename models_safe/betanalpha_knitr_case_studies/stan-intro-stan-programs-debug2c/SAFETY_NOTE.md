# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no top-level data variables and no observed-data sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; the only sampling statement is the built-in prior `x ~ normal(a * b, 1)` for the top-level parameter `x`, and there is no protected data interface to observe.
