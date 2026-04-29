# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the existing parameter prior sampling statements for `a`, `b`, and `sigma` so that each parameter is observed by its built-in prior before being used to compute `y_pred` or the likelihood. This preserves the same posterior/log density because Stan sampling statements add to the log density commutatively. The data file is unchanged.
