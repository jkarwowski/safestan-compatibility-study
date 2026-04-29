# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the observation model was vectorized from elementwise `y[t] ~ normal(...)` statements inside a loop to a single top-level `y ~ normal(...)` statement. The latent AR(1) prior for `h` was rewritten from indexed sequential normal statements, including a statement inside a loop, to the equivalent single built-in `multi_normal` prior with the stationary AR(1) covariance matrix. No data fields were added or changed.
