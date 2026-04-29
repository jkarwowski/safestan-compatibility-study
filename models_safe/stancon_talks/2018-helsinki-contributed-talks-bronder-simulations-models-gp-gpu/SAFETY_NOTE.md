# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the parameter prior sampling statements for `rho`, `alpha`, and `sigma` before the covariance construction that uses those parameters. The covariance construction and likelihood are wrapped in a local block, preserving the same posterior density while satisfying SafeStan's requirement that parameters be given their unique built-in prior before model-block use. No data fields were added or changed. The protected variable `y` remains top-level data and is scored exactly once with a built-in distribution.
