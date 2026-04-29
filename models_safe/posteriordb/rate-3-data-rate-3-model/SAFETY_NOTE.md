# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k1`, `k2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations `k1` and `k2` are top-level data variables, each is observed exactly once with a plain built-in `binomial` sampling statement, and neither is used before observation. The parameter `theta` has a single built-in prior before it is used in the likelihood. Context data `n1` and `n2` are used only as binomial trial counts and are not protected.
