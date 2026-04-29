# SafeStan Safety Note

Compatibility: major.

Protected data: `vote_88`.

Generated files: none.

Reason: the observed likelihood is a built-in sampling statement, `vote_88 ~ normal_id_glm(x, alpha, beta, sigma)`, with `vote_86` and `incumbency_88` used only as context predictors. However, the parameters `alpha`, `beta`, and `sigma` have no explicit prior sampling statements. SafeStan requires each parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior/log density, while the original implicit flat/improper priors cannot be represented as valid density-neutral built-in prior sampling statements. Therefore this cannot be translated without a substantive density change.
