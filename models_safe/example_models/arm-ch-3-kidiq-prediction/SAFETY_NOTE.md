# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: `kid_score` is the observed response scored by the built-in likelihood `normal_id_glm(...)`. However, the parameters `alpha` and `beta` are used in the likelihood without any prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding proper priors for these unconstrained coefficients would change the posterior/log density, and there is no density-neutral built-in prior statement equivalent to the original improper flat priors. Therefore this model cannot be translated to SafeStan with only a minor same-density rewrite.
