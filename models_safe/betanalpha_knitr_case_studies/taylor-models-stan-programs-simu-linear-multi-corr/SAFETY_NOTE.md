# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `model` block, no sampling statements, no parameters, and no likelihood-scored top-level data variables. The only top-level data variable, `x0`, is a context input used for simulation in `generated quantities`, not an observed/protected variable.
