# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The model has no data block and no observed likelihood terms.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; the only sampling statement is the built-in prior `theta ~ gamma(1.25, 1.25)` for the top-level parameter `theta`.
