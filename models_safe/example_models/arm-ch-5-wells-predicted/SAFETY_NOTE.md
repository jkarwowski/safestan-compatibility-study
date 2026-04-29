# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the observed interface variable is `switched`, which is scored once by the built-in `bernoulli_logit_glm` likelihood. However, the model has unconstrained parameters `alpha` and `beta` with only Stan's implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before it is used. Adding proper priors for these unconstrained parameters would change the posterior/log density, so there is no minor same-density SafeStan rewrite.
