# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: manually corrected on 2026-04-30. The original looped vector observations `y[n] ~ normal(theta[indiv_idx[n]], sigma)` are represented by flattening `y` into a vector in observation-then-component order. The model builds the matching `theta_obs` vector with `theta_obs[(n - 1) * I + i] = theta[indiv_idx[n]][i]` and observes the protected top-level variable once with `y ~ normal(theta_obs, sigma)`. This preserves the same product normal likelihood while avoiding unsupported array-of-vector distribution arguments.
