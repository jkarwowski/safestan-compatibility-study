# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ normal(X * b, sigma)`, so `y` is the protected interface variable and `N`, `K`, and `X` are context inputs. However, the parameters `b` and `sigma` are used in the likelihood without any prior sampling statements. SafeStan requires each parameter to have exactly one built-in prior before use. Adding priors for the unconstrained vector `b` or the positive scale `sigma` would change the posterior/log density, so this cannot be repaired as a minor same-density rewrite.
