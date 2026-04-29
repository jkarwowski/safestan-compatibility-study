# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program does not condition on or score any top-level data variable; `mu` and `sigma` are context inputs used only for RNG generation in `generated quantities`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no likelihood statements, parameters, manual target manipulation, or other constructs rejected by SafeStan.
