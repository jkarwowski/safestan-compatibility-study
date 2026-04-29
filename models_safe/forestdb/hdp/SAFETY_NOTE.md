# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log_sum_exp(...)` marginalized categorical likelihood with a deterministic per-observation probability vector `y_prob[n] = sum_k local_weight[doc[n], k] * atom[k]` followed by the built-in observation statement `y ~ categorical(y_prob)`. This preserves the same likelihood because `categorical_lpmf(y[n] | y_prob[n])` equals the original log-sum over latent components. Also vectorized the Dirichlet priors for `local_weight` and `atom` so each top-level parameter is sampled exactly once and no prior sampling statement is inside a loop. No data fields were added or changed.
