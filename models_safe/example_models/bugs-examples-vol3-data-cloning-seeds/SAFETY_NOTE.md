# SafeStan Safety Note

Compatibility: minor.

Protected data: `n_safestan_cloned`, a deterministic cloned copy of the original observed counts `n`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the looped/indexed likelihood `n[i] ~ binomial_logit(...)` with a single top-level sampling statement for `n_safestan_cloned`. For each original row `i` and clone index `k = 1, ..., 8`, `n_safestan_cloned[(i - 1) * 8 + k] = n[i]` and `N_safestan_cloned[(i - 1) * 8 + k] = N[i]`. This preserves the original data-cloning likelihood exactly. Also vectorized the prior for `b` from looped `b[i] ~ normal(0.0, sigma)` statements to one top-level `b ~ normal(0.0, sigma)` statement so that the parameter prior is SafeStan-compatible.
