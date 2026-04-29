# SafeStan Safety Note

Compatibility: major.

Protected data: the model scores `log_earnings`, a transformed-data value defined as `log(earnings)`. Thus the observed likelihood is for logged earnings derived from top-level data `earnings`; `height` and `sex` are context predictors.

Generated files: none.

Reason: the protected observation is not a top-level data identifier on the left side of a sampling statement, and the parameters `alpha`, `beta`, and `sigma` have no built-in prior sampling statements before use. Adding proper priors for these unconstrained or half-constrained parameters would change the posterior/log density, so this cannot be repaired by a minor same-density SafeStan rewrite.
