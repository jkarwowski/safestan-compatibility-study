# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual marginalized mixture likelihood implemented with `target += log_sum_exp(...)` by an equivalent built-in Bernoulli sampling statement. Because `y` is binary, the finite mixture likelihood satisfies
`sum_k cluster_weight[k] * Bernoulli(y | cluster_prob[k]) = Bernoulli(y | dot_product(cluster_weight, cluster_prob))`.
The protected variable `y` is now observed exactly once as a top-level data variable with a plain sampling statement. Parameter priors were already explicit and unchanged. No data fields were added or changed.
