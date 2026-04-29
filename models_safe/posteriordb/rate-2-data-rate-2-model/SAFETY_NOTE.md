# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k1`, `k2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations `k1` and `k2` are top-level data variables and are each observed exactly once with plain built-in `binomial` sampling statements. The trial counts `n1` and `n2` are context inputs, and the parameters `theta1` and `theta2` each have exactly one built-in prior before their likelihood use.
