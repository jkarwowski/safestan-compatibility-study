# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is for `y`, currently written as indexed sampling statements inside a loop. That part could be mechanically vectorized, but the model has parameters `a`, `b`, and `sigma_y` with no explicit priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior/log density, and the existing unconstrained or one-sided-constrained parameters only have improper implicit flat priors. Therefore this model cannot be translated to SafeStan with only minor same-density changes.
