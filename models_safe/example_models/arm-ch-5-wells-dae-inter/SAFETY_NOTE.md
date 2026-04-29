# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the likelihood observes `switched` with the built-in `bernoulli_logit_glm` distribution, but the parameters `alpha` and `beta` have no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding proper priors for these unconstrained parameters would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
