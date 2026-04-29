# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no data block and no observed data likelihood; the two top-level parameter variables each have exactly one built-in prior sampling statement before any model-block use, and there are no forbidden manual target manipulations.
