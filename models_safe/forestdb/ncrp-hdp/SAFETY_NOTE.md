# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original likelihood used manual `target += log_sum_exp(...)` scoring for the observed word/category variable `y`. This was algebraically rewritten as a built-in categorical likelihood with probabilities `y_prob[n][v] = sum_k local_weight[doc[n]][k] * atom[k][v]`. The looped Dirichlet priors for `local_weight` and `atom` were vectorized so parameter-prior sampling statements are not inside loops. `doc`, `D`, `K`, `V`, and `N` remain context inputs. No data fields were added; `data_safe.json` equals the supplied data.
