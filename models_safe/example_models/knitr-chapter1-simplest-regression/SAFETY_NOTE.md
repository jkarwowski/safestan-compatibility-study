# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes `y` with a built-in normal sampling statement, but the parameters `a`, `b`, and `sigma` have no explicit prior sampling statements before they are used. SafeStan requires every parameter to have exactly one built-in prior. Adding proper priors for the unconstrained regression coefficients or the positive scale parameter would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
