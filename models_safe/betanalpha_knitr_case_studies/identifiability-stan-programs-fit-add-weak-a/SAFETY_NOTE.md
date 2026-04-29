# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observational likelihood scores the top-level data variable `y` with `y ~ normal(a + b, sigma)`, so `y` is the protected interface. Parameter `a` has a built-in prior, but parameter `b` is used in the likelihood without any prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a prior for unconstrained `b` would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
