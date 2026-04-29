# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model-block sampling statements so that `mu` is given its built-in prior before it is used in the prior for `theta`. The posterior density is unchanged because the same sampling statements are retained and only their order is changed. No data changes were required; `sigma` and `J` remain unprotected context inputs.
