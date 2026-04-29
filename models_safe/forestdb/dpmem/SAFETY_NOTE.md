# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual marginalized mixture likelihood implemented with `target += log_sum_exp(...)` by the algebraically equivalent built-in Bernoulli likelihood `y ~ bernoulli(dot_product(cluster_weight, cluster_prob))`. This is exact because, for binary `y` and simplex weights `w`, `sum_k w[k] * Bernoulli(y | p[k]) = Bernoulli(y | sum_k w[k] * p[k])`. No data fields were added or changed.
