# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the observed likelihood is `partyid7 ~ normal_id_glm(x, alpha, beta, sigma)`, so `partyid7` is the protected interface variable and the other data variables are context predictors/configuration. However, the parameters `alpha`, `beta`, and `sigma` are used in this likelihood without any prior sampling statements. SafeStan requires every top-level parameter to have exactly one built-in prior before it is used. Adding priors for these unconstrained or half-constrained parameters would change the posterior/log density rather than being a density-preserving mechanical rewrite.
