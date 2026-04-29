# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the three parameter prior sampling statements so that `a`, `b`, and `sigma` are each given their built-in prior before they are used in the likelihood for `y`. This preserves the original log density because Stan sampling statements add commutative log-density terms. No data changes were required; `N` and `x` remain context inputs.
