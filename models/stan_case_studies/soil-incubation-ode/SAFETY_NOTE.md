# SafeStan Safety Note

Compatibility: minor.

Protected data: `eCO2mean`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the likelihood from a loop over `eCO2mean[t]` to a single top-level `eCO2mean ~ normal(...)` sampling statement. Moved the deterministic ODE prediction into the `model` block after the explicit priors so parameters are not used before their priors. The data file is unchanged and no deterministic fields were added. The posterior/log density is unchanged.
