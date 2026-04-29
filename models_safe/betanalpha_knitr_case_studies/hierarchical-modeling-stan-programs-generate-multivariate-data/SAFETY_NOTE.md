# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not condition on any top-level data variable with a sampling statement; all declared data variables are context inputs for simulation.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. There is no model-block likelihood, no `target +=` manipulation, and no parameters requiring priors. The RNG calls are used only for simulation in `transformed data` and `generated quantities`, not for scoring protected data.
