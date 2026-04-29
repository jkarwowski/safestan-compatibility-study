# SafeStan Safety Note

Compatibility: minor.

Protected data: `y1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the parameter prior statements for `rho`, `alpha`, and `sigma` to the beginning of the `model` block, before those parameters are used to construct the Gaussian-process covariance. This preserves the same joint density because the order of log-density additions is immaterial. No data fields were added or changed.
