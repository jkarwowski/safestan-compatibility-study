# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no data block, no parameters, no sampling statements, and no manual log-density manipulation; it only defines constants in `transformed data` and simulates quantities in `generated quantities`.
