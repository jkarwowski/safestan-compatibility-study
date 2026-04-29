# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `x0`, is a context input used for simulation in `generated quantities` and is not scored by any sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; the program has no model likelihood, no parameters requiring priors, and no protected observations.
