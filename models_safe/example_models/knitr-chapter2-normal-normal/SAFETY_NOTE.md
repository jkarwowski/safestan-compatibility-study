# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the two model-block sampling statements so that the parameter `theta` receives its built-in prior before it is used in the likelihood for protected data `y`. This preserves the posterior/log density because Stan sampling statements add to the log density commutatively. No data changes were required.
