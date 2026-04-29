# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is the built-in statement `y ~ binomial(n, p)`, so `y` is the protected data interface and the other data variables are context inputs. However, the parameters `sigma_theta` and `sigma_distance` have no explicit prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these positive real parameters would change the posterior/log density, and their implicit unconstrained improper priors cannot be represented as a SafeStan-compatible built-in prior by a minor same-density rewrite.
