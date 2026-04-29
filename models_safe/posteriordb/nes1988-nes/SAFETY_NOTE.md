# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the observed response `partyid7` is scored once with a built-in normal likelihood, but the model has parameters `beta` and `sigma` with no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for the unconstrained `beta` coefficients or the lower-bounded `sigma` parameter would change the posterior/log density rather than being a minor same-density rewrite.
