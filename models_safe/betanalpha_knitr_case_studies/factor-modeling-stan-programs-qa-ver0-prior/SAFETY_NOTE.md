# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The top-level data variables `N_fine_t` and `fine_t` are context inputs used only to configure and compute generated quantities; no data variable is scored by a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. Both parameters have exactly one built-in prior sampling statement in the model block, and the program contains no arbitrary target manipulation or protected-data likelihood to rewrite.
