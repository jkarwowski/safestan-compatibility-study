# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter priors for `rho`, `alpha`, and `sigma` appear before those parameters are used to construct the Gaussian-process covariance. Local declarations were split from parameter-dependent assignments to preserve Stan validity and the same posterior density. No data changes were made.
