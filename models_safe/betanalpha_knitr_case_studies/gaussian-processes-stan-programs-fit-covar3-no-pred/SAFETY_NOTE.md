# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the top-level parameters `rho`, `alpha`, and `sigma` are each given their built-in prior before they are used to build the Gaussian-process covariance. The covariance and Cholesky factor computation was inlined into the `multi_normal_cholesky` likelihood. No data fields were added or changed.
