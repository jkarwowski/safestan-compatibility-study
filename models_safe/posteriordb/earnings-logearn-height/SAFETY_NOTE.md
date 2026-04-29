# SafeStan Safety Note

Compatibility: major.

Protected data: the model scores `log_earn`, a transformed-data value computed as `log(earn)` from the top-level data variable `earn`.

Generated files: none.

Reason: the likelihood is applied to a transformed-data variable rather than a plain top-level data identifier, and the parameters `beta` and `sigma` have no built-in prior sampling statements before use. Adding proper priors for these unconstrained/one-sided parameters would change the posterior, and replacing the likelihood with one directly on `earn` would change the density. Therefore this is not a minor same-density SafeStan translation.
