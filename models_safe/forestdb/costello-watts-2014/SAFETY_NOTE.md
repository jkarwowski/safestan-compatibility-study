# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of indexed scalar observations `y[n] ~ bernoulli(theta[group[n]])` with the equivalent vectorized sampling statement `y ~ bernoulli(theta[group])`. This preserves the same Bernoulli likelihood while making the protected observation a single top-level data variable observed exactly once. No data changes were required.
