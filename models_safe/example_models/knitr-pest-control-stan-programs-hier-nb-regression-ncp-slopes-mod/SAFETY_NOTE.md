# SafeStan Safety Note

Compatibility: as-is.

Protected data: `complaints`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `complaints` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. All parameters have one built-in prior sampling statement before their transformed-parameter dependencies are used in the likelihood.
