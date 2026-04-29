# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no model block, no sampling statements, no parameters, and no protected observed likelihood interface; all top-level data variables (`theta_l`, `theta_u`, and `delta`) are context inputs used deterministically.
