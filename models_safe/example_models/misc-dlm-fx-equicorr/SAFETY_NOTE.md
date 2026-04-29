# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed interface variable `y` is scored once with the built-in `gaussian_dlm_obs` distribution, but the model has top-level parameters `sigma` and `W_diag` with only lower bounds and no explicit priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these positive parameters would change the posterior/log density, and there is no same-density finite uniform prior corresponding to their original implicit improper flat priors. Therefore a SafeStan-compatible translation would require a substantive density change.
