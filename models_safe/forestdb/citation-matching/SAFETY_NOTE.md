# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual marginalized mixture likelihood implemented with `target += log_sum_exp(...)` by an equivalent built-in Bernoulli sampling statement. For each binary observation, `sum_k cluster_weight[k] * Bernoulli(y[n] | cluster_prob[k])` is exactly `Bernoulli(y[n] | dot_product(cluster_weight, cluster_prob))`, so the posterior/log density is preserved while satisfying SafeStan's requirement that protected data be observed once with a built-in distribution. No data values were changed or added.
