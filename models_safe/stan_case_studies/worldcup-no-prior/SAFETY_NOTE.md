# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood scores `sqrt_dif`, a transformed-data quantity computed from `score_1` and `score_2`, rather than a top-level data variable.

Generated files: none.

Reason: the model is not SafeStan-compatible without substantive changes. The observed likelihood is placed on a transformed-data expression, so it is not a plain top-level protected data variable. More importantly, `sigma_a` and `sigma_y` are unconstrained-positive parameters with no explicit built-in priors; SafeStan requires every parameter to have exactly one prior sampling statement before use. Adding proper priors for these scale parameters would change the posterior/log density, and an improper density-neutral prior cannot be represented as a SafeStan built-in prior sampling statement.
