# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes `y` with `y ~ normal(y_hat, sigma)`, so `y` is the protected interface variable. However, the scale parameters `sigma`, `sigma_a`, and `sigma_b` are unconstrained only by lower bounds and have no explicit prior sampling statements in the original model. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these scale parameters would change the posterior/log density, and the original implicit improper priors cannot be represented as a minor SafeStan-compatible rewrite.
