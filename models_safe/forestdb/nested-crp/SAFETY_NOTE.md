# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`. Context data: `K`, `N`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual marginalized Bernoulli-mixture likelihood implemented with `target += log_sum_exp(...)` by the equivalent built-in sampling statement `y ~ bernoulli(dot_product(cluster_weight, cluster_prob))`. For binary observations, `sum_k cluster_weight[k] * Bernoulli(y | cluster_prob[k])` equals `Bernoulli(y | dot_product(cluster_weight, cluster_prob))`, so the posterior density is unchanged. No data fields were added or modified.
