# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ normal_id_glm(x, alpha, beta, sigma)`, so `y` is the protected interface variable. However, the parameters `alpha`, `beta`, and `sigma` are used in the likelihood without any prior sampling statements. SafeStan requires each parameter to have exactly one built-in prior before use. Adding proper priors for these unconstrained or half-constrained parameters would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
