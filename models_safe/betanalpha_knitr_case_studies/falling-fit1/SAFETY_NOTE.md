# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_t_fall` (reshaped to a one-dimensional top-level array in `data_safe.json`).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: The original elementwise observation statements `obs_t_fall[n, h] ~ normal(...)` occurred inside loops and used an indexed left-hand side, which is not SafeStan-compatible for protected data. The safe model deterministically flattens the observed array in `(n, h)` order, fills a matching mean array with `mu_t_fall[(n - 1) * N_heights + h] = t_fall(g, heights[h])`, and scores the protected data exactly once with `obs_t_fall ~ normal(mu_t_fall, sigma_t)`. This is the same sum of normal log densities. Priors and generated quantities are otherwise unchanged.
