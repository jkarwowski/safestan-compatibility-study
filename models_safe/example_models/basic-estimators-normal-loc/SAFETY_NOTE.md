# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The original program has no top-level data variables; `y` is a fixed transformed-data constant, not an external data interface variable.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the fixed normal factor from `y ~ normal(mu, 1)` to `mu ~ normal(y, 1)`. This is a mechanical same-density rewrite for the normal distribution: the resulting Stan target has the same quadratic contribution, while the sampling statement now targets the top-level parameter `mu`, satisfying SafeStan's parameter-prior discipline. No data fields were added; `data_safe.json` remains `{}`.
