# SafeStan Safety Note

Compatibility: major.

Protected data: `earnings`.

Generated files: none.

Reason: `earnings` is the observed response, scored once by the built-in normal likelihood. However, the parameters `beta` and `sigma` have no explicit prior sampling statements before being used in that likelihood. SafeStan requires every parameter to have exactly one built-in prior. Adding priors for the unconstrained regression coefficients or the positive scale parameter would change the original posterior/log density, so this is not a minor same-density translation.
