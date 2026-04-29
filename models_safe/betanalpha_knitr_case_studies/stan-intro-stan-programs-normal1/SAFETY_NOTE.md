# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The only top-level data variable, `N`, is a size/configuration input and is not observed with a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += normal_lpdf(...)` statements with equivalent built-in sampling statements. The conditional density for `y` was vectorized as `y ~ normal(theta, 1)`, and the prior for `theta` was placed before `y` so that `theta` is not used before its prior. The data were unchanged.
