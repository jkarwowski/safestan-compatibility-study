# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`, a deterministic top-level copy of the originally scored response values `y[2:T]`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood used indexed observations inside a loop (`y[t] ~ normal(...)`), which is not SafeStan-compatible for protected data. The likelihood was rewritten as one vectorized built-in sampling statement on the top-level protected variable `y_obs`. The rewritten data fields are deterministic reshapes of the original data: `T_lik = max(T - 1, 0)` and, for `i = 1, ..., T_lik`, `y_obs[i] = y[i + 1]`, `y_lag[i] = y[i]`, and `x_lik[i] = x[i + 1]`. For the supplied data, `T = 1`, so these length-`T_lik` fields are empty, matching the original empty likelihood loop. The parameter priors were already built-in and remain before any parameter use.
