# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the observed likelihood is `partyid7 ~ normal(...)`, but the model has parameters `beta` and `sigma` with no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for the unconstrained `beta` vector or the half-line-constrained `sigma` would change the posterior/log density rather than being a minor same-density translation.
