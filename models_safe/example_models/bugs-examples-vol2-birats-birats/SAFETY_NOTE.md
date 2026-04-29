# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the repeated `beta[n] ~ multi_normal(...)` prior into the single top-level statement `beta ~ multi_normal(...)`, and vectorized the elementwise normal observation model into the single protected-data statement `y ~ normal(eta, sigma_y)` using a deterministic local mean array `eta`. This removes sampling statements from loops and gives protected data a plain top-level left-hand side without changing the posterior density. No data changes were required; `data_safe.json` is the supplied data.
