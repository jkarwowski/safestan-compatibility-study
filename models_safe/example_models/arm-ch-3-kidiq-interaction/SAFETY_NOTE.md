# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed response is the top-level data variable `kid_score`, scored once by the built-in likelihood `kid_score ~ normal_id_glm(x, alpha, beta, sigma)`. However, the parameters `alpha` and `beta` have no explicit prior sampling statements; they rely on Stan's implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for `alpha` or `beta` would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite.
