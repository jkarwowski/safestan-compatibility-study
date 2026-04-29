# SafeStan Safety Note

Compatibility: minor.

Protected data: `r0`, `r1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so all top-level parameters (`b`, `mu`, `alpha`, `beta1`, `beta2`, and `sigma_sq`) receive their built-in prior sampling statements before they are used in likelihood terms. This preserves the same posterior/log density because Stan sampling statements add commutative log-density contributions. No data changes were required.
