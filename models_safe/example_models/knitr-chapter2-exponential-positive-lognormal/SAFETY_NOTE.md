# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the existing built-in prior sampling statements for `a`, `b`, and `sigma` so that each parameter is given its prior before being used to compute `y_pred` or in the protected-data likelihood. This preserves the same posterior/log density because the sampling statements are the same and only their order changed. No data changes were required.
