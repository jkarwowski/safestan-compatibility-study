# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes `y` with `y ~ normal(mu, sigma)`, so `y` is the protected interface variable. The model computes the GARCH volatility path using lagged `y` before the sampling statement; that pre-observation use could be handled mechanically with a deterministic data copy. However, the parameters `mu`, `alpha0`, `alpha1`, and `beta1` have no explicit prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for the unconstrained or half-bounded parameters would change the posterior density, and the dependent constraint on `beta1` cannot be made density-neutral by a simple `uniform(0, 1 - alpha1)` statement. Therefore a SafeStan-compatible version would require a substantive density/model change rather than a minor same-density rewrite.
