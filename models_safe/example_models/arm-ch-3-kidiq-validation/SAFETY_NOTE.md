# SafeStan Safety Note

Compatibility: major.

Protected data: `ppvt`.

Generated files: none.

Reason: `ppvt` is the observed response scored by the built-in `normal_id_glm` likelihood. The predictors `hs` and `afqt` are context data used to build the design matrix and should not be protected. However, the parameters `alpha` and `beta` have no explicit priors in the original Stan program, only Stan's implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before it is used. Adding proper priors for `alpha` or `beta` would change the posterior/log density, and there is no same-density built-in proper prior corresponding to an unconstrained implicit flat prior. Therefore a SafeStan-compatible translation would require a substantive density change.
