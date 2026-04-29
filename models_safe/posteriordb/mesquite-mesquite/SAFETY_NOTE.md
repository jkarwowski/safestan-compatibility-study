# SafeStan Safety Note

Compatibility: major.

Protected data: `weight`.

Generated files: none.

Reason: `weight` is the observed response scored by the likelihood, but the parameters `beta` and `sigma` have no sampling statements before they are used. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for the unconstrained `beta` vector or the positive scale `sigma` would change the posterior/log density, so this is not a minor same-density translation.
