# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no data block and therefore no protected observed interface variables. Both top-level parameters have exactly one built-in prior sampling statement, and `y` is given its prior before it is used in the prior scale for `x`.
