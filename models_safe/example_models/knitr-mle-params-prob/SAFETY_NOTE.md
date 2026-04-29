# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ bernoulli(theta)`. The context variable `N` is used only for sizing, and the parameter `theta` has exactly one built-in prior statement before it is used in the likelihood.
