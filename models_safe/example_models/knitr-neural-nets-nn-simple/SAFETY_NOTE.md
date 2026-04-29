# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: changed the matrix priors from `to_vector(...) ~ normal(0, 2)` to the equivalent plain top-level parameter sampling statements `alpha ~ normal(0, 2)` and `beta ~ normal(0, 2)`. Moved the deterministic hidden-layer computation to occur after both parameter priors. Replaced the loop of indexed likelihood statements `y[n] ~ categorical_logit(...)` with the equivalent single built-in statement `y ~ categorical_logit_glm(...)`, so the protected data variable is observed exactly once with a plain top-level left-hand side. No data fields were added; `data_safe.json` is the supplied data unchanged.
