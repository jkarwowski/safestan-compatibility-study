# SafeStan Safety Note

Compatibility: minor.

Protected data: `eCO2mean`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of indexed likelihood statements `eCO2mean[t] ~ normal(eCO2_hat[t], sigma)` with the equivalent vectorized built-in sampling statement `eCO2mean ~ normal(eCO2_hat, sigma)`. This makes the protected observation a top-level plain left-hand-side variable scored exactly once and outside control flow. No data changes were required; `totalC_t0`, `t0`, `N_t`, and `ts` remain ordinary context inputs.
