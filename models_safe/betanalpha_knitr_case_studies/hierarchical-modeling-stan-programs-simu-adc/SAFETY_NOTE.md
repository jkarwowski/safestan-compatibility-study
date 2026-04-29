# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no top-level data variables, no parameters, and no model-block likelihood or prior sampling statements; it only defines constants in `transformed data` and simulates quantities in `generated quantities`.
