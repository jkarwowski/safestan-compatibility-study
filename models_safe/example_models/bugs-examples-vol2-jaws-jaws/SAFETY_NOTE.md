# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the repeated likelihood from a loop with indexed left-hand side `Y[n] ~ multi_normal(mu, Sigma)` to the equivalent vectorized statement `Y ~ multi_normal(mu, Sigma)`. This preserves the same summed multivariate-normal likelihood while making the protected observation a top-level plain identifier observed exactly once and outside control flow. No data changes were required.
