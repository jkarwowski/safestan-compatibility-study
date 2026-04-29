# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the only top-level data variable scored by a likelihood statement (`y ~ normal(...)`). The model cannot be translated to SafeStan with only a minor same-density rewrite because the parameter `sigma_tau` has no prior/sampling statement in the original model. SafeStan requires every top-level parameter to have exactly one built-in prior before use; adding a prior for `sigma_tau` would change the posterior/log density. Other issues, such as moving priors before the likelihood and vectorizing the looped `beta_raw` prior, would be mechanical, but the missing prior is a substantive incompatibility.
