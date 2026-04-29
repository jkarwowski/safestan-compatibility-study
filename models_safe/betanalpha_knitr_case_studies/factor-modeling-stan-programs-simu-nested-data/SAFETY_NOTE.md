# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no top-level data variables, no parameters, and no likelihood/sampling statements in the model block; it is a prior/data-simulation program using RNG calls only in allowed non-model blocks.
