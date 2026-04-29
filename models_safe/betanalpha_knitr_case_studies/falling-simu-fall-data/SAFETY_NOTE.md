# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not condition on any top-level data variable with a sampling statement; all data variables are context inputs used for simulation in `generated quantities`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no parameters, no model-block likelihood, and no protected observations to score. The RNG calls in `generated quantities` simulate derived quantities and do not condition on protected data.
