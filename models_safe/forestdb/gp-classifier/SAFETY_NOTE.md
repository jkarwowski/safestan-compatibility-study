# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with the built-in distribution `bernoulli_logit` using a plain sampling statement. The other data variables, `N` and `x`, are context inputs and are not scored. All parameters have explicit built-in priors before the likelihood uses the transformed parameter `f`.
