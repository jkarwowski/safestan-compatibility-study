# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The observed data variable `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement, `y ~ binomial(N, theta)`. The data variable `N` is context data used as the binomial trial count and is not protected. The parameter `theta` has exactly one built-in prior sampling statement before it is used in the likelihood.
