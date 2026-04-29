# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. No top-level data variable is conditioned on with a sampling statement; `N_heights`, `heights`, and `N_drops` are context inputs used only for generated quantities.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model-block likelihood terms, no parameters requiring priors, and no forbidden direct target manipulation.
