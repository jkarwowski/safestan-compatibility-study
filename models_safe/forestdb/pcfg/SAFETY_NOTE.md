# SafeStan Safety Note

Compatibility: minor.

Protected data: `counts`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += counts[c, k] * log(rule_prob[c, k])` likelihood with a single built-in `multinomial` sampling statement for the top-level protected count table. This is the normalized built-in count likelihood corresponding to the same categorical-count log probability. The Dirichlet prior on `rule_prob` was vectorized so the top-level parameter is sampled exactly once and not inside a loop. The data file is unchanged.
