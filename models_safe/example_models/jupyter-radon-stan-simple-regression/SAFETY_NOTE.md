# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model observes `y` with a built-in normal sampling statement, but the parameters `alpha`, `beta`, and `sigma` have no prior sampling statements before they are used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for the unconstrained regression coefficients or the positive scale parameter would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite.
