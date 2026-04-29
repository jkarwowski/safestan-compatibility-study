# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the likelihood observation is already a top-level sampling statement, `switched ~ bernoulli_logit_glm(x, alpha, beta)`, but the parameters `alpha` and `beta` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding priors for these unconstrained parameters would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
