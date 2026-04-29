# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `model` block, no parameters, and no sampling statements that score top-level data; `x0` and `tau_x` are context inputs used only for simulation in `generated quantities`.
