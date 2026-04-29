# SafeStan Safety Note

Compatibility: as-is.

Protected data: `r`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `r` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `r ~ binomial_logit(n, b);`. Context data `N` and `n` are not scored. Each parameter has exactly one built-in prior before later use in the model block.
