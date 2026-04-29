# SafeStan Safety Note

Compatibility: minor.

Protected data: `rule_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += counts[c, k] * log(rule_prob[c, k])` scoring with a built-in categorical likelihood over a deterministic expansion of `counts`. The added data fields are `N_obs = sum(counts)`, `obs_class`, and `rule_obs`; in row-major order, category `k` is repeated `counts[c, k]` times for each class `c`, with `obs_class` recording the corresponding class. The protected variable is the reshaped observation `rule_obs`; `C`, `K`, `counts`, `N_obs`, and `obs_class` are context data. The Dirichlet prior was vectorized as one top-level prior statement for `rule_prob`, outside loops. This preserves the original target contribution exactly because `rule_obs ~ categorical(rule_prob[obs_class])` contributes `sum_{c,k} counts[c,k] * log(rule_prob[c,k])` and introduces no multinomial combinatorial term.
