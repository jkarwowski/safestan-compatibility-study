# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ binomial_logit(N, alpha)`. The data variable `N` is context data used as the binomial trial count. The parameter `alpha` has exactly one built-in prior sampling statement before it is used in the likelihood.
