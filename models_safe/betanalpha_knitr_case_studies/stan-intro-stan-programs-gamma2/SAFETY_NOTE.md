# SafeStan Safety Note

Compatibility: as-is.

Protected data: none; the program has no top-level data variables and no observed data likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `theta ~ gamma(1.25, 1.25)` for the top-level parameter `theta`, and there are no protected observations.
