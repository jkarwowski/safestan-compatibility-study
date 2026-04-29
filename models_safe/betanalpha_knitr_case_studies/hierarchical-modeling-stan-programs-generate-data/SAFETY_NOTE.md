# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. No top-level data variable is conditioned on with a sampling statement; all data variables are context inputs for this prior/data-generating program.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model-block likelihood or parameter priors, no protected observations, and no forbidden direct log-density manipulation.
