# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that each parameter (`beta0`, `theta`, and `sigma`) receives its built-in prior before being used in the likelihood. This is a mechanical same-density change because Stan log-density contributions are additive. The protected observation `y` remains a top-level data variable and is scored exactly once with `poisson_log`. No data changes were required.
