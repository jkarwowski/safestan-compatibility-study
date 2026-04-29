# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no top-level data variables and therefore no protected observed interface. The parameter `x` is given exactly one built-in prior sampling statement before any model-block use.
