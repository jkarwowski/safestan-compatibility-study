# SafeStan Safety Note

Compatibility: major.

Protected data choice: the intended modelled interface would include `y` for the observed uncensored values and `N_censored` for the censored-count contribution. `U` and `N_observed` are context/configuration inputs.

Generated files: none.

Reason: the model is not SafeStan-compatible as written because it uses manual `target +=` scoring for the censored observations. More importantly, the parameter `mu` is unconstrained and has no built-in prior; SafeStan requires every parameter to be scored by exactly one built-in prior before use. Adding a proper prior to `mu` would change the posterior/log density relative to the original implicit improper flat prior, so a same-density minor rewrite is not available.
