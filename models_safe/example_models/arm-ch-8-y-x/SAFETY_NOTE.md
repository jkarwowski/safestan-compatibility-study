# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed response scored by the likelihood statement `y ~ normal_id_glm(...)`. `x` and `N` are context inputs.

Generated files: none.

Reason: the likelihood statement itself uses a top-level protected data variable with a built-in distribution, but the model has no prior sampling statements for the parameters `alpha`, `beta`, and `sigma`. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior/log density, and the existing unconstrained or half-line constrained parameters correspond only to improper flat priors, not density-neutral proper built-in priors. Therefore a SafeStan-compatible translation would require a substantive density change.
