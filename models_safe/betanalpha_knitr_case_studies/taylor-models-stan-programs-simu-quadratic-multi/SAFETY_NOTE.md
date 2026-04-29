# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `x0`, is a context input used for simulation in `generated quantities` and is not scored by any likelihood statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no parameters, no `model` block likelihood or prior sampling statements, and no forbidden manual log-density manipulation.
