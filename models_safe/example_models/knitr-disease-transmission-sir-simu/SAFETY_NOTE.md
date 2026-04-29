# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no `model` block, no sampling statements, and no observed/scored data likelihood; all top-level data variables are context inputs used for simulation in `generated quantities`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. There are no parameters requiring priors and no protected observations requiring SafeStan observation statements.
