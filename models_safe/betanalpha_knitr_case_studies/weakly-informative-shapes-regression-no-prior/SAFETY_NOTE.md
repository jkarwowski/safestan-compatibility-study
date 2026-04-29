# SafeStan Safety Note

Compatibility: major.

Protected data: `y`. Context data: `N`, `x`.

Generated files: none.

Reason: the likelihood observation `y ~ normal(beta * x + alpha, sigma)` is a valid protected-data sampling statement, but the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements before they are used. SafeStan requires every parameter to have exactly one built-in prior. Adding proper priors would change the posterior/log density, and the original implicit flat/improper priors for the unconstrained and positive-constrained parameters cannot be represented as a minor same-density SafeStan rewrite.
