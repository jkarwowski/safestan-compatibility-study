# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `N`, is a context input used to size simulated generated quantities and is not scored by any likelihood statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model block sampling statements, no parameters requiring priors, and no protected observed data interface.
