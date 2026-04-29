# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `y` is a top-level data variable observed exactly once with the built-in `bernoulli` distribution, and it is not used before that observation. `N` is a context input. The parameter `theta` has exactly one built-in prior, `beta(4, 4)`, before it is used in the likelihood.
