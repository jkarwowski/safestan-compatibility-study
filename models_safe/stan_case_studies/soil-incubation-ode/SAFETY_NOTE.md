# SafeStan Safety Note

Compatibility: minor.

Protected data: `eCO2mean`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the observation likelihood loop was vectorized from indexed statements `eCO2mean[t] ~ normal(eCO2_hat[t], sigma)` to the single plain protected-data statement `eCO2mean ~ normal(eCO2_hat, sigma)`. This preserves the same likelihood density while satisfying SafeStan's requirement that a protected top-level data variable appear exactly once on the left side of a built-in sampling statement. No data fields were added or changed.
