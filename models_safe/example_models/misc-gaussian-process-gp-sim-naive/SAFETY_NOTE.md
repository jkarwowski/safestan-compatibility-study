# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The model has no observed data likelihood: `N` and `x` are context inputs used to construct the Gaussian-process covariance, and the only sampling statement is the built-in prior `y ~ multi_normal(mu, K)` for the top-level parameter `y`.
