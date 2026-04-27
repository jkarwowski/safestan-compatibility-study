# SafeStan Safety Note

Compatibility: minor.

Protected data: `y` (the rat weights, represented in `data_safe.json` as a row-major vector of length `N * T`).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reshaped the original `matrix[N, T] y` to `vector[N * T] y` so the likelihood can be written as one plain vectorized sampling statement, `y ~ normal(mu_y, sigma_y)`, rather than nested sampling statements. The deterministic relation is `y[(n - 1) * T + t] = original_y[n, t]` for `n = 1..N` and `t = 1..T`. Moved the deterministic construction of `alpha`, `beta`, and the likelihood mean into the model block after the existing priors. No priors or likelihood terms were changed.
