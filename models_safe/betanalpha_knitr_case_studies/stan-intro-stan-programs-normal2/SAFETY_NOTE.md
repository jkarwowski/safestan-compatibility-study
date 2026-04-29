# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The only top-level data variable, `N`, is a size/configuration input and is not scored by the model.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the two manual `target += normal_lpdf(...)` statements with equivalent built-in sampling statements. The prior for `theta` is placed before `y ~ normal(theta, 1)` so that `theta` is not used before its SafeStan prior. No data changes were required.
