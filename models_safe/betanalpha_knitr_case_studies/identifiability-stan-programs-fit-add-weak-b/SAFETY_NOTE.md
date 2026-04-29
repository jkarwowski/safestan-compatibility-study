# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observational likelihood is `y ~ normal(a + b, sigma)`, so `y` is the protected data variable. However, parameter `a` is used in the likelihood without any prior sampling statement, corresponding to Stan's implicit improper flat prior on an unconstrained real parameter. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for `a` would change the posterior/log density, and there is no minor same-density SafeStan rewrite for this improper prior.
