# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `y` with `y ~ normal(beta[1] + beta[2] * x, sigma)`, so `y` is the protected interface variable and `x` and `N` are context data. However, the parameters `beta` and `sigma` have no explicit priors. SafeStan requires every parameter to be scored exactly once by a built-in prior before use in the model block. Adding priors for unconstrained `beta` and lower-bounded-only `sigma` would change the posterior/log density, since these are implicit improper priors rather than finite-bounded uniform priors that can be made explicit density-neutrally. Therefore a SafeStan-compatible translation would require a substantive model change.
