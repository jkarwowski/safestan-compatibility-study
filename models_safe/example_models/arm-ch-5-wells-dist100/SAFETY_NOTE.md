# SafeStan Safety Note

Compatibility: major.

Protected data: `switched`.

Generated files: none.

Reason: the likelihood observes `switched` with the built-in `bernoulli_logit_glm` distribution, using `dist` only as context through deterministic transformed-data predictors. However, the parameters `alpha` and `beta` have no sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these unconstrained parameters would change the posterior/log density, and their implicit flat priors are improper rather than finite bounded uniforms. Therefore no same-density minor SafeStan translation is available.
