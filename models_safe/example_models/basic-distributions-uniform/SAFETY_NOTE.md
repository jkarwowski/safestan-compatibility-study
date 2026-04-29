# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no data block and therefore no protected observed interface variables. The sole parameter `y` has exactly one built-in prior sampling statement before any use.
