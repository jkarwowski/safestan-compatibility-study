# SafeStan Safety Note

Compatibility: minor.

Protected data: `C_hat`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the loop of indexed observation statements `C_hat[n] ~ lognormal(...)` with one vectorized sampling statement `C_hat ~ lognormal(log_C, sigma)` whose left side is the protected top-level data variable. Added a model-local deterministic array `log_C` to hold `log(C[n, 1])` values before the vectorized likelihood. Parameter priors are unchanged and remain before any model-block use of transformed quantities depending on those parameters. `data_safe.json` is unchanged.
