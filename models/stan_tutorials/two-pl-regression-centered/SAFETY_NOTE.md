# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the protected observations are already top-level data and are scored by a plain vectorized `y ~ bernoulli_logit(eta)` likelihood, but the parameter `gamma` has no explicit proper prior. SafeStan requires explicit proper priors for parameters, and adding any proper prior for unconstrained `gamma` would change the posterior/log density. Therefore no same-density SafeStan translation is available as a minor mechanical rewrite.
