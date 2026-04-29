# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed response `y` is scored by a built-in sampling statement, but the model has unconstrained parameters `alpha` and `beta` that are used in the likelihood without any explicit prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for these unconstrained parameters would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
