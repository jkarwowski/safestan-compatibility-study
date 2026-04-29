# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `N`, is a context input used as an array size in generated quantities and is not scored by any likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; the program contains no protected observations, no parameters requiring priors, and no forbidden direct log-density manipulation.
