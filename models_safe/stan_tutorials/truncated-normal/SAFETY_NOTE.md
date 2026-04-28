# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is for the top-level data variable `y`, but the original model scores it elementwise as `y[n] ~ normal(mu, sigma) T[, U]` inside a loop, which is not allowed for protected data under SafeStan. That part could likely be vectorized mechanically, but the model also leaves the unconstrained parameter `mu` with an implicit improper flat prior. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding any proper built-in prior for `mu` would change the posterior/log density, so an exact SafeStan translation is not a minor rewrite.
