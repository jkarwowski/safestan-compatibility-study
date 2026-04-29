# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The only top-level data variable, `N_calibrations`, is a context input used as a size and is not observed/scored by any likelihood statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model-block likelihood, no parameters requiring priors, and no protected observations. The generated-quantities simulation uses `normal_rng` and does not condition on data.
