# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced manual `target += normal_lpdf(...)` terms with equivalent built-in sampling statements. The parameter prior is now `theta ~ normal(0, 1)`, and the elementwise likelihood loop for `y[n]` was vectorized to the single protected observation statement `y ~ normal(theta, 1)`. No data changes were required; `N` remains an ordinary context size variable.
