# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed response scored by the likelihood statement `y ~ normal(X * b, sigma)`. However, the parameters `b` and `sigma` have no explicit built-in prior sampling statements before they are used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for unconstrained `b` or lower-bounded `sigma` would change the original posterior/log density, so this cannot be translated as a minor same-density rewrite.
