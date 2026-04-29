# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ bernoulli_logit(eta)`, so `y` is the protected interface variable. However, the model has an unconstrained parameter `gamma` with only Stan's implicit improper flat prior, and `gamma` is used in the prior for `theta` without having its own built-in prior sampling statement. SafeStan requires every top-level parameter to have exactly one built-in prior before use. Adding any proper prior for `gamma` would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite. The elementwise `theta[j] ~ normal(...)` prior inside a loop would also need mechanical vectorization, but the missing proper prior for `gamma` is the blocking issue.
