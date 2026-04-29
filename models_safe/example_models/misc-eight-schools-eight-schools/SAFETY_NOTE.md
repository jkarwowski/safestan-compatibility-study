# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ normal(theta, sigma)`, so `y` is the protected interface variable and `sigma`/`J` are context data. However, the parameters `mu` and `tau` have no explicit built-in prior sampling statements in the original model, and `theta ~ normal(mu, tau)` uses them before any prior. SafeStan requires every parameter to be scored exactly once by a built-in prior before use. Adding proper priors for `mu` or `tau` would change the posterior/log density, while the original implicit improper flat priors cannot be represented as SafeStan-compatible built-in sampling statements. Therefore this cannot be translated with only a minor same-density rewrite.
