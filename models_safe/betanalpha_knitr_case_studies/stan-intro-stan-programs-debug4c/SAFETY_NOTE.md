# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no top-level data variables and no observed-data likelihood statements.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement assigns the top-level parameter `x` a built-in `normal` prior before any model-block use, and there are no protected observations to score.
