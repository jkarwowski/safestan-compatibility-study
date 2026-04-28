# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed response vector `y` is the likelihood variable and is scored once with `y ~ bernoulli_logit(eta)`. However, the parameter `gamma` has no prior in the original Stan program, relying on Stan's implicit improper flat prior. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding any proper prior for the unconstrained parameter `gamma` would change the posterior/log density. The indexed `theta[j]` prior inside a loop could be mechanically vectorized, but the missing prior for `gamma` prevents a same-density SafeStan translation.
