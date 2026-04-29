# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The data variables `N`, `D`, and `x` are context inputs used to construct the Gaussian-process covariance; no top-level data variable is observed with a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only sampling statement is the built-in prior `y ~ multi_normal(mu, K)` for the top-level parameter `y`, and `y` is not used before that prior.
