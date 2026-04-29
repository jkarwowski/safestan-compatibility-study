# SafeStan Safety Note

Compatibility: minor.

Protected data: `eCO2mean`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the indexed likelihood loop `eCO2mean[t] ~ normal(eCO2_hat[t], sigma)` with the equivalent vectorized built-in sampling statement `eCO2mean ~ normal(eCO2_hat, sigma)`. This makes the protected observation appear exactly once on the left side as a plain top-level identifier and avoids observing it inside a loop. The data file is unchanged.
