# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: `switched` is the modelled observation, scored once with the built-in `bernoulli_logit_glm` distribution. `dist` and `arsenic` are context predictors used to construct the transformed-data design matrix. However, the parameters `alpha` and `beta` have no prior sampling statements before they are used in the likelihood. SafeStan requires every top-level parameter to have exactly one built-in prior before use. Adding proper priors to these unconstrained parameters would change the posterior/log density, so there is no minor same-density rewrite.
