# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed likelihood is `kid_score ~ normal_id_glm(x, alpha, beta, sigma)`, so `kid_score` is the protected interface variable and `mom_hs`/`mom_iq` are predictors. However, the parameters `alpha`, `beta`, and `sigma` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior/log density, and the existing unconstrained or one-sided constrained parameters do not imply finite proper uniform priors that can be added density-neutrally. Therefore this model cannot be translated with only a minor same-density rewrite.
