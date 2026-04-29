# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model put the prior sampling statement on transformed parameter `beta`, which SafeStan does not allow. The rewritten model places the equivalent built-in multivariate normal prior on the top-level parameter `beta_tilde`. Since `beta = R_inv * beta_tilde`, the induced covariance for `beta_tilde` is `100 * R * R'`, computed deterministically from context data in transformed data as `beta_tilde_cov`. The protected-data likelihood `y ~ normal(Q * beta_tilde + alpha, sigma)` is unchanged, and no data fields were added.
