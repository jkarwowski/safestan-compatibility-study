# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that each parameter (`alpha`, `beta`, and `sigma`) receives its built-in prior sampling statement before being used in the likelihood for `y`. This preserves the same posterior density because Stan sampling statements add log-density terms commutatively. No data changes were required; `x`, `u`, `county`, `N`, and `J` remain unprotected context inputs.
