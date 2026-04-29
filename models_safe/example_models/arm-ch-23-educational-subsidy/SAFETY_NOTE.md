# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is the built-in sampling statement `y ~ bernoulli_logit(y_hat)`, so `y` is the protected interface variable. However, the top-level parameter `mu_beta` has no sampling statement and is not otherwise given a proper built-in prior. SafeStan requires every parameter to have exactly one prior sampling statement before use. Adding a prior for `mu_beta` would change the posterior/log density, and there is no minor same-density rewrite that makes this improper unused parameter SafeStan-compatible while preserving the original model.
