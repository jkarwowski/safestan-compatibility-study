# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observation `y ~ multi_normal(mu, Sigma)` is a built-in sampling statement, but the parameters `beta` and `Sigma` have no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding proper priors for the unconstrained regression coefficients and covariance matrix would change the original improper-prior posterior/log density, so this is not a minor same-density translation.
