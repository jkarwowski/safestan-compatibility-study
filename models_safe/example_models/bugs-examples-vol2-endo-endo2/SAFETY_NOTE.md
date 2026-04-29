# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the explicit manual `target +=` multinomial/Bernoulli log-probability terms with one built-in vectorized `bernoulli_logit` sampling statement. Added `Y_safestan`, with deterministic relation `Y_safestan[i] = 1` for every `i = 1, ..., I`; this is the Bernoulli/category indicator corresponding to the original transformed-data row `Y[i] = [1, 0]`. The logit is `beta * (est[i, 1] - est[i, 2])`, so `bernoulli_logit_lpmf(1 | ...)` is exactly the original `log(p[i, 1])` contribution. The deterministic construction of `est` was rewritten as a per-row conditional fill from the same context inputs; no protected data are read before their sampling statement.
