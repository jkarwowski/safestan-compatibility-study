# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the three parameter prior sampling statements for `length_scale`, `alpha`, and `sigma` before the GP covariance computation in the `model` block. This preserves the same posterior/log density while satisfying SafeStan's requirement that parameters be given their unique built-in prior before any model-block use. No data fields were added or changed.
