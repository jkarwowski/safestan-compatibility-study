# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no top-level data variables and no observed-data likelihood; the only sampling statement is the prior for parameter `x`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The parameter `x` has exactly one built-in prior sampling statement before any use, and there are no protected observations to score.
