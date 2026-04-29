# SafeStan Safety Note

Compatibility: major.

Protected data: `earnings`.

Generated files: none.

Reason: the observed likelihood is `earnings ~ normal(...)`, with the remaining top-level data vectors used as predictors/context. However, the parameters `beta` and `sigma` have no explicit priors in the original Stan program and are used directly in the likelihood. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for unconstrained `beta` or lower-bounded `sigma` would change the posterior/log density, and there is no same-density minor rewrite for the original implicit improper priors.
