# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed likelihood is `kid_score ~ normal(...)`, so `kid_score` is the protected interface variable. However, the parameters `beta` and `sigma` are used in the likelihood without any built-in prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for the unconstrained `beta` and lower-bounded `sigma` would change the original posterior/log density, because the original model relies on implicit improper flat priors. Therefore this cannot be translated with only a minor same-density rewrite.
