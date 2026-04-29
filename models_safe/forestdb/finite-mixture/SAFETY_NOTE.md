# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_mix(...)` Bernoulli-mixture likelihood with the equivalent built-in sampling statement `y ~ bernoulli(theta[1] * p[1] + theta[2] * p[2])`. For binary observations, a two-component Bernoulli mixture has marginal success probability `theta[1] * p[1] + theta[2] * p[2]`, so this preserves the same likelihood while satisfying SafeStan's requirement that protected data be observed exactly once by a built-in distribution. No data fields were added or changed.
