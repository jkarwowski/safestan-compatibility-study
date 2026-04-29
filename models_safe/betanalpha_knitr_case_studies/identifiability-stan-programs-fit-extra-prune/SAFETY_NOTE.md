# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ normal(a, sigma)`. The context inputs `N` and `sigma` are not protected. The parameter `a` has a built-in prior, `a ~ normal(0, 100)`, before it is used in the likelihood.
