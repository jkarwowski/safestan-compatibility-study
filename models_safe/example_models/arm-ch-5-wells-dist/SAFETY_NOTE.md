# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the likelihood observes `switched` with the built-in `bernoulli_logit_glm` distribution, but the parameters `alpha` and `beta` have no explicit priors. SafeStan requires each parameter to be sampled exactly once from a built-in prior before use. Adding proper priors for these unconstrained parameters would change the posterior/log density, so this is not a minor same-density rewrite.
