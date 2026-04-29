# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual marginalized mixture likelihood implemented with `target += log_sum_exp(...)` and `bernoulli_lpmf(...)` by the equivalent built-in sampling statement `y ~ bernoulli(dot_product(cluster_weight, cluster_prob))`. This preserves the density because a mixture of Bernoulli distributions with simplex weights has marginal success probability equal to the weighted average of the component probabilities. No data changes were required.
