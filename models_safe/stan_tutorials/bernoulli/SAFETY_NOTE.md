# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once by the built-in `bernoulli` distribution using a plain sampling statement. The parameter `theta` has exactly one built-in prior sampling statement before it is used in the likelihood.
