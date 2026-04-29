# SafeStan Safety Note

Compatibility: major.

Protected data: `switc`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `switc` with `switc ~ bernoulli_logit_glm(x, alpha, beta)`, but the parameters `alpha` and `beta` have no explicit priors. They therefore have Stan's implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before it is used. Adding proper priors for the unconstrained parameters would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
