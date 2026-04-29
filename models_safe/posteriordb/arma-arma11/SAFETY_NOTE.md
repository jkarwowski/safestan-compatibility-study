# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the residual likelihood `err ~ normal(0, sigma)` as the equivalent observation likelihood `y ~ normal(nu, sigma)`. Added `y_safestan_copy`, a deterministic copy of `y`, so that the ARMA recursion can be computed before the protected observation statement without reading protected data early. In `data_safe.json`, `y_safestan_copy[i] = y[i]` for all `i = 1, ..., T`.
