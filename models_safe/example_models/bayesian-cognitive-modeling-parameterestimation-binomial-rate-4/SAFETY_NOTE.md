# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `k` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `k ~ binomial(n, theta);`. The data variable `n` is context data used as the binomial size and is not protected. Both parameters have exactly one built-in prior before use in the model block.
