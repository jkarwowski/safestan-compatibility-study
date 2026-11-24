# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: manually corrected on 2026-04-30. The original looped vector observations `y[n] ~ normal(theta[indiv_idx[n]], sigma)` are represented by flattening `y` into a vector in observation-then-component order. The transformed parameter `theta_obs` is the matching mean vector, and the protected top-level variable is observed once with `y ~ normal(theta_obs, sigma)`. The non-centered `eta` parameter is also flattened into a top-level vector and reconstructed with `segment(...)` when computing `theta`, preserving the iid standard normal prior while satisfying SafeStan's plain-identifier prior requirement.
