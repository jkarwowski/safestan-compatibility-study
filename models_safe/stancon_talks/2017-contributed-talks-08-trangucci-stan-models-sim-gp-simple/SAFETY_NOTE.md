# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The Stan program has no likelihood sampling statement for any top-level data variable; all top-level data are context inputs used for prior predictive simulation in `generated quantities`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model block is empty, there are no parameters requiring priors, and there is no protected observation to score.
