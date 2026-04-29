# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only top-level data variable scored by a sampling statement is `complaints`, and it is observed exactly once with a plain built-in sampling statement. All parameters have exactly one built-in prior sampling statement before the protected-data likelihood is evaluated.
