# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observed likelihood is `switched ~ bernoulli_logit_glm(x, alpha, beta)`, with `dist`, `arsenic`, and `educ` used only as predictor/context data through deterministic transformed-data construction of `x`. However, the parameters `alpha` and `beta` have no prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding priors for these unconstrained parameters would change the posterior/log density, so this cannot be represented as a minor same-density rewrite.
