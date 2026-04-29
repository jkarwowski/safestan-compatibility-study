# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the observational model from a loop of indexed statements `y[n] ~ normal(...)` to a single top-level protected-data sampling statement `y ~ normal(theta_obs, sigma)`. The local `theta_obs` array is a deterministic model-block helper with `theta_obs[n] = theta[indiv_idx[n]]`, so the likelihood density is unchanged. No data fields were added; `data_safe.json` is the supplied data unchanged.
