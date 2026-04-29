# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the existing built-in parameter prior sampling statements for `a`, `b`, and `sigma` so that each parameter is given its unique prior before it is used in the model block. The protected observation `y` remains a top-level data variable and is scored exactly once with the same `lognormal(log(y_pred), sigma)` likelihood. No data values were changed or added.
