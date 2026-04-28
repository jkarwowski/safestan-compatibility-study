# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with the built-in sampling statement `y ~ binomial(N, theta);`. The context input `N` is used only as binomial size/configuration, and the parameter `theta` has exactly one built-in prior sampling statement before it is used.
