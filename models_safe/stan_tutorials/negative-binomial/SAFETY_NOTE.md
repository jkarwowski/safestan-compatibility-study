# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with the built-in `neg_binomial` distribution using a plain sampling statement. Parameters `alpha` and `beta` each have exactly one built-in prior sampling statement before they are used in the likelihood.
