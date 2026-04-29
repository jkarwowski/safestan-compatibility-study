# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs_rule`, a deterministic expansion of the original `counts` table. `C`, `K`, `N_obs`, and `obs_context` are context inputs.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += counts[c, k] * log(rule_prob[c, k])` loop with one vectorized built-in likelihood statement, `obs_rule ~ categorical(rule_prob[obs_context])`. The original `counts` field is replaced by deterministic arrays computed as follows: `N_obs = sum(counts)`, and for each `c = 1..C` and `k = 1..K` in row-major order, append `counts[c, k]` copies of `c` to `obs_context` and `k` to `obs_rule`. This gives exactly the same log density as the original target increments. The Dirichlet prior loop was vectorized to `rule_prob ~ dirichlet(rep_vector(1.0, K))` so the top-level parameter is sampled once outside loops.
