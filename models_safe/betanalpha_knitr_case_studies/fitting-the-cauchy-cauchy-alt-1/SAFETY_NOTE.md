# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no data block and no observed/protected interface variables. Each top-level parameter is assigned exactly one built-in prior sampling statement in the model block, and there is no arbitrary target manipulation.
