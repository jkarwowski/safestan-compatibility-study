# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model-block sampling statements so that all parameters (`theta_trans`, `mu`, and `tau`) receive their built-in prior sampling statements before the protected observation `y` is scored. This is a same-density mechanical change because Stan sampling statement contributions are additive and commutative. No data changes were made; `sigma` and `J` remain context inputs.
