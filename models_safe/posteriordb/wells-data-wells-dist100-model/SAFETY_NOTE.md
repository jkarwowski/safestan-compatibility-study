# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observed likelihood is `switched ~ bernoulli_logit_glm(x, alpha, beta)`, so `switched` is the protected interface variable while `N` and `dist` are context inputs. However, the parameters `alpha` and `beta` have no prior sampling statements before being used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these unconstrained parameters would change the posterior/log density, so this cannot be translated by a minor same-density rewrite.
