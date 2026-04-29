# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic top-level data copy of `y` with `y_safestan_copy[n] = y[n]` for `n = 1..N`, and used it in `transformed data` so protected `y` is not read before its model-block observation. Added `phi ~ uniform(0, 1)`, which is density-neutral for the existing `real<lower=0, upper=1>` parameter and satisfies SafeStan's unique-prior rule. `y_new` remains unprotected context data used only for generated-quantities predictive evaluation; it is not conditioned on in the model.
