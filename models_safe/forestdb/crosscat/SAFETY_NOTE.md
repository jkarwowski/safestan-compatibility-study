# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual marginalized mixture likelihood implemented with `target += log_sum_exp(...)` and `bernoulli_lpmf(...)` by the algebraically equivalent built-in sampling statement `y ~ bernoulli(mixture_prob)`, where `mixture_prob = dot_product(cluster_weight, cluster_prob)`. For binary observations, `sum_k w_k Bernoulli(y | p_k)` is exactly `Bernoulli(y | sum_k w_k p_k)`, so the posterior/log density is preserved while avoiding arbitrary target manipulation. The input data are unchanged.
