# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed response `kid_score` is scored by a built-in likelihood, but the parameters `alpha` and `beta` are used in that likelihood without any prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these unconstrained regression coefficients would change the posterior/log density, and there is no density-neutral proper built-in prior for unconstrained real parameters. Therefore this model cannot be translated to SafeStan with only minor same-density changes.
