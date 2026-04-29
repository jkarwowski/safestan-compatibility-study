# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the `sigma_a ~ cauchy(0, 2.5)` prior to occur before `alpha ~ normal(mu_a, sigma_a)`, because `sigma_a` is used in the `alpha` prior and SafeStan requires each parameter to be sampled from its prior before model-block use. This is a same-density reordering of additive log-density terms. No data changes were made.
