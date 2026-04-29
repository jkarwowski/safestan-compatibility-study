# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target +=` conditional likelihood with a vectorized built-in `bernoulli_logit` sampling statement. The added top-level data field `y_safestan` is deterministic from the original transformed-data outcome: for every `i = 1:I`, `y_safestan[i] = Y[i,1] = 1` from the original program. The transformed-data predictor `x` is `est[i,1] - est[i,2]`, so each original row contribution `log(p[i,1]) * Y[i,1] + log(p[i,2]) * Y[i,2]` is exactly `bernoulli_logit_lpmf(1 | beta * x[i])`. The prior `beta ~ normal(0, 1000)` was already a valid built-in prior and is kept before any use of `beta`.
