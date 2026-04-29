# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the observed likelihood is the single built-in statement `partyid7 ~ normal(...)`, so `partyid7` is the modelled interface variable. However, the parameters `beta` and `sigma` have no explicit prior sampling statements and are used directly in that likelihood. SafeStan requires every parameter to be sampled exactly once from a built-in prior before any model-block use. Adding priors for the unconstrained regression coefficients or the positive scale parameter would change the posterior/log density, because the original model uses implicit improper flat priors. Therefore this cannot be translated with only a minor same-density rewrite.
