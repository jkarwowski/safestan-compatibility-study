# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k1`, `k2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations `k1` and `k2` are top-level data variables, each is observed exactly once with a plain built-in `binomial` sampling statement, and the parameter `theta` has exactly one built-in prior before use.
