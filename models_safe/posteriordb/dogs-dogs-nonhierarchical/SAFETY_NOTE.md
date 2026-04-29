# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because the original model used `y` in `transformed data` to build lagged avoidance/shock counts before the observation statements. The likelihood was mechanically vectorized so the protected top-level variable `y` is observed exactly once with a plain built-in `bernoulli` sampling statement. Parameter prior statements were moved before any model-block use of transformed parameters depending on them, and `to_vector(z) ~ normal(0, 1)` was rewritten as the equivalent top-level `z ~ normal(0, 1)` prior.

Deterministic data augmentation: `y_safestan_copy[j][t] = y[j][t]` for all dogs `j` and trials `t`.
