# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual marginalized mixture likelihood implemented with `target += log_sum_exp(...)` by the equivalent built-in Bernoulli observation `y ~ bernoulli(mixed_prob)`, where `mixed_prob = dot_product(cluster_weight, cluster_prob)`. For binary observations, `sum_k cluster_weight[k] * bernoulli_pmf(y[n] | cluster_prob[k])` is exactly `bernoulli_pmf(y[n] | dot_product(cluster_weight, cluster_prob))`, so the posterior/log density is preserved. The parameter priors were already explicit built-in sampling statements and remain before parameter use. `data_safe.json` is unchanged.
