# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the latent state `x` and observation `y_obs` were represented as vectors so that the latent Ornstein-Uhlenbeck transition model can be written as one built-in `multi_normal` prior for the top-level parameter `x`. The mean vector and covariance matrix are computed by the same Gaussian Markov recursions as the original sequential transition statements, preserving the same joint density for `x` conditional on `mu`, `gamma`, `tau`, `x0`, and the time data. The protected observation `y_obs` is then scored exactly once with `normal(x, sigma)`. No data values were added or changed; the JSON array for `y_obs` is valid for the vector declaration.
