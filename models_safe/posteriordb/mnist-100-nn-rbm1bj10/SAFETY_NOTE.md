# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the neural-network logits computation until after all parameter prior sampling statements so no parameter is used before its prior. Replaced `to_vector(alpha) ~ ...` and `to_vector(beta) ~ ...` with equivalent matrix-vectorized priors on the top-level parameters `alpha` and `beta`. Replaced the loop of indexed likelihood statements `y[n] ~ categorical_logit(...)` with a single vectorized built-in statement `y ~ categorical_logit(v)` using a local `array[N] vector[K]` of logits. `data_safe.json` is identical to the supplied data.
