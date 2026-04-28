# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation model is the single built-in sampling statement `y ~ bernoulli_logit(eta)`, but the parameter `gamma` has no prior sampling statement and is used to compute `theta`. SafeStan requires every parameter to have exactly one built-in prior before use. Adding a proper prior for unconstrained `gamma` would change the posterior/log density, so this cannot be translated as a minor same-density rewrite.
