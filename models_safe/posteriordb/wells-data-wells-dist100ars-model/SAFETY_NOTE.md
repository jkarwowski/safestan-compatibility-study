# SafeStan Safety Note

Compatibility: major.

Protected data choice: `switched` is the observed response scored by the model likelihood. `dist`, `arsenic`, and `N` are context inputs used to construct predictors and sizes, not protected observations.

Generated files: none.

Reason: the likelihood statement `switched ~ bernoulli_logit_glm(x, alpha, beta)` is a built-in sampling statement with a top-level protected data variable, but the parameters `alpha` and `beta` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding priors for these unconstrained regression coefficients would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
