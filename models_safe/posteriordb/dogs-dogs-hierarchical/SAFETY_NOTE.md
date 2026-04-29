# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because protected data cannot be read in `transformed data` before its observation. The history-derived predictors `prev_shock` and `prev_avoid` are computed from this copy. Replaced the indexed likelihood statements inside loops with a single vectorized `y ~ bernoulli(p)` statement whose probabilities are computed in the model block after parameter priors. Added `a ~ uniform(0, 1)` and `b ~ uniform(0, 1)`, which are density-neutral for parameters already constrained to `[0, 1]` and satisfy SafeStan's unique-prior requirement.

Deterministic data augmentation: `y_safestan_copy` is exactly equal to `y` elementwise.
