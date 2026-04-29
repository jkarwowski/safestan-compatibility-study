# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of indexed observation statements `y[n] ~ bernoulli(theta[group[n]])` with the equivalent vectorized built-in sampling statement `y ~ bernoulli(theta[group])`. This makes the protected top-level data variable appear exactly once on the left side of a sampling statement, outside loops, without changing the likelihood. The supplied data were unchanged.
