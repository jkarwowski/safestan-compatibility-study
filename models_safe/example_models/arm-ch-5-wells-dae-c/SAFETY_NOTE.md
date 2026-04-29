# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observed likelihood is `switched ~ bernoulli_logit_glm(x, alpha, beta)`, with `dist`, `arsenic`, and `educ` used only as predictors/context. However, the parameters `alpha` and `beta` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for these unconstrained parameters would change the posterior/log density rather than being a same-density mechanical rewrite.
