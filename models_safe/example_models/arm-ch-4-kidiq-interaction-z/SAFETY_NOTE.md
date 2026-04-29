# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: `kid_score` is the only top-level data variable scored by a sampling statement (`kid_score ~ normal_id_glm(...)`). The predictors `mom_hs` and `mom_iq` are context data used to build the design matrix. However, the parameters `alpha`, `beta`, and `sigma` have no explicit priors in the original model. SafeStan requires each parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior/log density, and the existing implicit flat/improper priors cannot be represented as a same-density SafeStan rewrite.
