# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the elementwise likelihood loop `y[n] ~ normal(...)` as a single vectorized sampling statement `y ~ normal(mu, sigma)` with `mu` computed deterministically in the model block after all parameter priors. This preserves the same product normal likelihood while making the protected observation a top-level plain identifier observed exactly once and outside any loop. No data changes were required.
