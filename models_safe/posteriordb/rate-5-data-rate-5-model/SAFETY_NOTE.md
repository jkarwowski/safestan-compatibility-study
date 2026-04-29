# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k1`, `k2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data variables and are each observed exactly once with plain built-in `binomial` sampling statements. The context inputs `n1` and `n2` are used only as binomial trial counts and generated-quantity bounds.
