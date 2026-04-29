# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the elementwise/indexed sampling statements so that all parameter priors and the protected observation use plain top-level identifiers exactly once. Specifically, `tau[j] ~ gamma(...)` was rewritten as `tau ~ gamma(...)`, the per-`k` prior on `theta[k]` was rewritten as a single top-level `theta ~ normal(mu_theta, sigma_theta)` using deterministic local arrays, and the per-`k` likelihood `Y[k] ~ normal(...)` was rewritten as a single `Y ~ normal(m, sigma_C)` after constructing the same deterministic mean array. No data fields were added or changed.
