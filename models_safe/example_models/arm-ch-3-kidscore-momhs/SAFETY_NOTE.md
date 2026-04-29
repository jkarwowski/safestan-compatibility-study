# SafeStan Safety Note

Compatibility: major.

Protected data: `kid_score`.

Generated files: none.

Reason: the observed likelihood is `kid_score ~ normal_id_glm(x, alpha, beta, sigma)`, so `kid_score` is the protected data variable and `mom_hs`/`N` are context inputs. However, SafeStan requires every parameter to have exactly one built-in prior before use in the model block. The original model gives `sigma` a Cauchy prior, but `alpha` and `beta` have no explicit proper priors and are used in the likelihood. Adding proper priors for these unconstrained parameters would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
