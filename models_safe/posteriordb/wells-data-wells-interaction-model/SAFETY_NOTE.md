# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observed likelihood is `switched ~ bernoulli_logit_glm(x, alpha, beta)`, with `dist` and `arsenic` used only as predictors. However, the parameters `alpha` and `beta` have no prior sampling statements; in Stan this is an implicit improper flat prior. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior/log density, so this cannot be made SafeStan-compatible by a minor same-density rewrite.
