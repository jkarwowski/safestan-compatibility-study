# SafeStan Safety Note

Compatibility: as-is.

Protected data: `k1`, `k2`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations are top-level data variables and each is observed exactly once with a plain built-in sampling statement. The context inputs `n1` and `n2` are used only as binomial trial counts. The parameters `theta1` and `theta2` each have an explicit built-in prior before being used in the likelihood.
