# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of indexed observation statements `y[n] ~ bernoulli(theta[group[n]])` with the equivalent vectorized top-level observation statement `y ~ bernoulli(theta[group])`. This preserves the same likelihood while making the protected observation a plain top-level data variable scored exactly once outside control flow. The data file is unchanged.
