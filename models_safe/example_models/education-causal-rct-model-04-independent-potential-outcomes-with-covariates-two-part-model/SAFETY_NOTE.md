# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_pos` and `log_y_pos_safestan`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the Bernoulli likelihood for `y_pos` so the protected variable is observed once as a plain top-level identifier. Replaced the conditional likelihood `log(y[n]) ~ normal(...)` for observations with `y_pos[n] == 1` by a top-level protected deterministic reshape `log_y_pos_safestan`, scored once with a vectorized normal likelihood. Added `N_pos_safestan`, deterministically equal to `sum(y_pos)`, to size that positive-outcome likelihood vector. In `data_safe.json`, `log_y_pos_safestan[k]` is `log(y[n_k])`, where `n_k` are the indices with `y_pos[n_k] == 1` in increasing order. These changes preserve the original target density for the supplied interface under the deterministic reshape.
