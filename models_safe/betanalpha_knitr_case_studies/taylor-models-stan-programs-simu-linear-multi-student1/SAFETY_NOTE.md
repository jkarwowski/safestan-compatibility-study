# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `model` block, no sampling statements, no parameters, and no observed/scored top-level data variables. The sole data input `x0` is an unprotected context input used only for simulation in `generated quantities`.
