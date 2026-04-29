# SafeStan Safety Note

Compatibility: major.

Protected data: `r` is the observed series scored by the likelihood statement `r ~ normal(mu, sigma)`.

Generated files: none.

Reason: the model is not SafeStan-compatible as written because `r` is used in `transformed parameters` to compute the GARCH volatility recursion before it is observed in the model block. That issue could only be handled by a deterministic data copy. More importantly, the parameters `mu` and `alpha0` have no explicit built-in prior sampling statements and correspond to improper flat priors in the original Stan program. SafeStan requires each parameter to have exactly one built-in prior before use; adding proper priors for these parameters would change the posterior/log density. Therefore a SafeStan version cannot be produced by a minor same-density rewrite.
