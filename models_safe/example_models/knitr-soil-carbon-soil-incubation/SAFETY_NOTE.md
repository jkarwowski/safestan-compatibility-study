# SafeStan Safety Note

Compatibility: minor.

Protected data: `eCO2mean`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the likelihood from an indexed sampling statement inside a loop, `eCO2mean[t] ~ normal(eCO2_hat[t], sigma)`, to a single vectorized top-level sampling statement, `eCO2mean ~ normal(eCO2_hat, sigma)`. This preserves the same normal likelihood while satisfying SafeStan's requirement that protected data be scored exactly once with a plain top-level identifier outside loops. No data fields were added or changed.
