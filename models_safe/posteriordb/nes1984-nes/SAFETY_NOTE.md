# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the observed likelihood is the vectorized normal sampling statement `partyid7 ~ normal(...)`, so `partyid7` is the protected interface variable. However, the parameters `beta` and `sigma` have no explicit priors in the original model. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for the unconstrained `beta` coefficients or the positive unbounded `sigma` would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
