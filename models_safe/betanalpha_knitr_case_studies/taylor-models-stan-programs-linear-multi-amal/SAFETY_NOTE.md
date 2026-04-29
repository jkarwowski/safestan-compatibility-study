# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: inlined the construction of the regression coefficient vector in the likelihood so that `beta0` and `beta1` are not used in the model block before their prior sampling statements. The statistical model and likelihood are unchanged. `M`, `N`, `X`, and `x0` remain unprotected context data. `data_safe.json` is unchanged; no deterministic copies or reshapes were added.
