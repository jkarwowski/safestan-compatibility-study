# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no data block and no observed data variables scored by sampling statements.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; the only sampling statement is a built-in prior for the top-level parameter `x`, and there are no protected observations.
