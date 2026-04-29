# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with the built-in distribution `bernoulli_logit`. The other data variables `I`, `J`, `N`, `ii`, and `jj` are context inputs used as sizes and indices. Each parameter (`alpha`, `beta`, and `theta`) has exactly one built-in prior sampling statement before it is used.
