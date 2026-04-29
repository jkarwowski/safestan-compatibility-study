# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that each parameter (`a`, `b`, and `sigma`) is given its built-in prior before it is used in the model block. The likelihood for the protected observation `y` is unchanged and remains a single top-level sampling statement. The input data are unchanged.
