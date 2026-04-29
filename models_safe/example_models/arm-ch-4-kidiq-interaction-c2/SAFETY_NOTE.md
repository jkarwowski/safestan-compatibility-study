# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed response `kid_score` is scored by the built-in likelihood `normal_id_glm(...)`, while `mom_hs` and `mom_iq` are context predictors used to construct the design matrix. However, the parameters `alpha`, `beta`, and `sigma` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before it is used. Adding proper priors would change the posterior/log density, and the existing implicit flat/improper priors cannot be represented as a minor SafeStan-compatible rewrite.
