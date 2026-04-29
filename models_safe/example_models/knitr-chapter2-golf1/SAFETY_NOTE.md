# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `y` with `y ~ binomial(n, p)`, but the parameter `sigma` has no prior sampling statement. SafeStan requires every parameter to be sampled exactly once from a built-in prior before it is used in the model block. Adding a proper prior for `sigma` would change the posterior/log density, and the existing lower-bound constraint only implies an improper flat density on `[0, infinity)`, not a proper built-in prior that can be made explicit as a density-neutral minor rewrite.
