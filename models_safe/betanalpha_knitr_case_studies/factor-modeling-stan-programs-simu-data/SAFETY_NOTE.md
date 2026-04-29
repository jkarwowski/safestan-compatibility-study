# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no top-level data variables, no parameters, no model block likelihood, and no sampling statements; it is a prior/data simulation program using `transformed data` and `generated quantities` only.
