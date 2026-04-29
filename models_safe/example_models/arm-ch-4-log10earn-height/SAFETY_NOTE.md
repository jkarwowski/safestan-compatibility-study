# SafeStan Safety Note

Compatibility: major.

Protected data: none in generated files. The source model scores `log10_earn`, a transformed-data quantity computed as `log10(earn)`, rather than a top-level data variable.

Generated files: none.

Reason: the likelihood is written for a transformed-data variable, so there is no top-level protected observation that can be passed directly to SafeStan without changing the data interface or adding a new transformed observation. In addition, the parameters `alpha`, `beta`, and `sigma` have no explicit priors; adding proper priors would change the posterior, while SafeStan requires each parameter to have exactly one built-in prior sampling statement. Therefore this model cannot be translated with only minor same-density changes.
