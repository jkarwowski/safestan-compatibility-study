# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program contains no model block and no sampling statement that scores top-level data.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. All top-level data variables are context inputs used only to simulate generated quantities, and there are no parameters or likelihood terms requiring SafeStan protection.
