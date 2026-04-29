# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual marginalized mixture likelihood implemented with `target += log_sum_exp(...)` by the algebraically equivalent built-in observation statement `y ~ bernoulli(mix_prob)`, where `mix_prob = dot_product(cluster_weight, cluster_prob)`. This preserves the density because a finite mixture of Bernoulli distributions is Bernoulli with success probability equal to the mixture-weighted mean of the component probabilities. No data fields were added or changed.
