# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no data block and no observed likelihood interface to protect. Each top-level parameter is assigned exactly one built-in prior sampling statement in the model block, and no forbidden log-density manipulation constructs are used.
