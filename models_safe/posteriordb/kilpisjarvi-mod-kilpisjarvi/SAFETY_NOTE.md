# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ normal(alpha + beta * x, sigma)`, so `y` is the protected interface variable. The parameters `alpha` and `beta` have explicit built-in priors, but `sigma` has no sampling statement/prior in the original model and is used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for `sigma` would change the posterior density, while the existing lower bound only implies an improper flat density on `sigma > 0` and is not a finite bounded uniform prior that can be made explicit without changing the model. Therefore this cannot be translated with only a minor same-density rewrite.
