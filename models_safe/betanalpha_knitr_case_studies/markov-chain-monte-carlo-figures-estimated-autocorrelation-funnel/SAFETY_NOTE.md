# SafeStan Safety Note

Compatibility: minor.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the two parameter sampling statements so that `log_tau` receives its built-in prior before it is used in the prior for `x`. This preserves the same joint log density because Stan sampling statements add commutatively to the target density. No protected data variables are present.
