# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic elementwise copy of `y` with `y_safestan_copy[t] = y[t]` for all `t`, so the ARMA recursion can be computed without reading the protected variable before it is observed. Moved the parameter priors before any model-block use of those parameters. Re-expressed the residual likelihood `err ~ normal(0, sigma)` as the protected-data statement `y ~ normal(nu, sigma)`; because the copy equals `y` and `err[t] = y_safestan_copy[t] - nu[t]`, this preserves the original log density for the supplied data.
