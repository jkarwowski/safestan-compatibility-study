# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: `kid_score` is the observed response scored by the built-in likelihood statement `kid_score ~ normal_id_glm(...)`. However, the parameters `alpha` and `beta` are used in that likelihood without any prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding proper priors for the unconstrained `alpha` and `beta` parameters would change the original posterior/log density, so this cannot be translated as a minor same-density rewrite.
