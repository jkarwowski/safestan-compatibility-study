# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed data are scored elementwise as `y[n] ~ normal(mu, sigma) T[, U]`, which could be mechanically vectorized for SafeStan, and `sigma` has a finite-bounded implicit uniform prior that could be made explicit. However, `mu` is an unconstrained parameter with only an implicit improper flat prior. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use; adding any proper built-in prior for `mu` would change the posterior/log density. Therefore a SafeStan-compatible translation cannot preserve the model with only minor mechanical changes.
