# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `y` with `y ~ binomial(n, p)`, so `y` is the protected interface. However, the parameter `sigma` has no explicit prior sampling statement and is used to compute `p` before any prior. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding a proper prior for `sigma` would change the posterior/log density; the existing `<lower=0>` constraint corresponds only to an improper flat density on the positive half-line, not a proper built-in prior that can be added as a density-neutral minor rewrite.
