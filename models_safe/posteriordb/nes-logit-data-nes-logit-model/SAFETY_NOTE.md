# SafeStan Safety Note

Compatibility: major.

Protected data: `vote` is the observed response scored by the likelihood.

Generated files: none.

Reason: the likelihood uses a built-in sampling statement, `vote ~ bernoulli_logit_glm(x, alpha, beta)`, but the parameters `alpha` and `beta` have no prior sampling statements. SafeStan requires every parameter to be observed exactly once with a built-in prior before it is used in the model block. Adding proper priors to these unconstrained parameters would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
