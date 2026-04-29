# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `model` block so that the three parameter priors are applied before any model-block computation uses `rho`, `alpha`, or `sigma`. The Gaussian-process covariance and Cholesky factor are now computed in a nested local block after the priors, immediately before the single observation statement for `y_obs`. This preserves the same posterior/log density. The data file is unchanged.
