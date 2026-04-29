# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the observed likelihood is `partyid7 ~ normal(...)`, but the parameters `beta` and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for unconstrained `beta` and lower-bounded `sigma` would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
