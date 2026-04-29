# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observed likelihood is `switched ~ bernoulli_logit_glm(x, alpha, beta)`, where `switched` is the protected top-level data variable and `dist`, `arsenic`, and `educ` are ordinary predictors used to build `x`. However, the parameters `alpha` and `beta` have no prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding proper priors for these unconstrained parameters would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite.
