# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ binomial_logit(K, alpha)`. The context inputs `N` and `K` are not protected. All parameters (`mu`, `sigma`, and `alpha`) have exactly one built-in prior sampling statement before later use.
