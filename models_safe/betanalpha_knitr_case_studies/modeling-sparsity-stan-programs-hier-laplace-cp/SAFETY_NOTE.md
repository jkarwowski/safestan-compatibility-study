# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the two parameter prior sampling statements so that `tau` is observed with its prior before it is used in the hierarchical prior for `theta`. This preserves the same posterior/log density because Stan sampling statements add commutative log-density terms. No data fields were added or changed.
