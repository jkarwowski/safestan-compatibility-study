# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `model` block sampling statements and does not condition on any top-level data variable. `x0` is an unprotected context input used only in `generated quantities` to simulate draws and is not part of a protected likelihood interface.
