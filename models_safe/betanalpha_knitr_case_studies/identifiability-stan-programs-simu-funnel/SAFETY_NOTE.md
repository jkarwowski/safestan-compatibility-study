# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `N`, is a context input used as a size and is not observed/scored by any sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; the program contains no model-block likelihood or parameter priors, and it only simulates generated quantities from fixed transformed-data constants.
