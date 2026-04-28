# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because protected data cannot be read in `transformed data` before its sampling statement. The deterministic relation is `y_safestan_copy[n] = y[n]` for every `n = 1, ..., N`. Non-likelihood posterior-predictive summaries that need the observed successes use this copy. Added `phi ~ uniform(0, 1)`, which is density-neutral for the existing constrained parameter `real<lower=0, upper=1> phi` and satisfies SafeStan's unique-prior requirement. The protected observation `y` is scored exactly once by the built-in binomial distribution.
