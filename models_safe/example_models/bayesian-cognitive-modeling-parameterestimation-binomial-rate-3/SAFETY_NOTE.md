# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k1`, `k2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data variables, each is observed exactly once with a plain built-in `binomial` sampling statement, and the parameter `theta` has a single built-in prior before it is used.
