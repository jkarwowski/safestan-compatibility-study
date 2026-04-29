# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reshaped the original two-dimensional response array `y` into a one-dimensional row-major protected data vector, with `y[(i - 1) * J + j]` equal to the original `y[i, j]`. The looped likelihood with indexed left-hand side `y[i] ~ bernoulli_logit(theta - b[i])` was replaced by a single plain protected-data sampling statement `y ~ bernoulli_logit(eta)`, where `eta[(i - 1) * J + j] = theta[j] - b[i]`. This preserves the same Bernoulli-logit product likelihood and the same priors while satisfying SafeStan's requirement that protected data be observed exactly once with a plain top-level identifier.
