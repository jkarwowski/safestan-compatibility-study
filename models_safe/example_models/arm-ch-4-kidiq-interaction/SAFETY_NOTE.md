# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed likelihood is `kid_score ~ normal_id_glm(x, alpha, beta, sigma)`, with `mom_hs` and `mom_iq` used only as context predictors. However, the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding proper priors would change the posterior/log density, and the existing implicit flat/improper priors cannot be represented as SafeStan-compatible built-in prior sampling statements without a substantive density change.
