# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed response variable; it is the only top-level data variable scored by a sampling statement (`y ~ bernoulli_logit(eta)`). Other data variables (`I`, `J`, `N`, `ii`, `jj`, `x`, `Ik`) are context inputs.

Generated files: none.

Reason: the model contains unconstrained parameters `gamma` and `delta` with no explicit prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use in the model block. Adding proper priors for `gamma` and `delta` would change the posterior/log density, and their original implicit improper flat priors cannot be represented as a minor density-preserving SafeStan rewrite.
