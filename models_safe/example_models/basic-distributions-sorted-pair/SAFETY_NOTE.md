# SafeStan Safety Note

Compatibility: minor.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(-1, 1)` prior sampling statements for `x1` and `x2`. These match the finite bounds already declared on the parameters and are density-neutral up to a constant, while satisfying SafeStan's requirement that each parameter have exactly one built-in prior before use.
