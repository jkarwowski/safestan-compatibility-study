# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because protected data cannot be read in `transformed data` before its observation statement. The transformed-data summaries and generated-quantity diagnostic calculation that previously read `y` use this copy instead. Added `theta ~ uniform(0, 1)`, which is density-neutral for `theta` because it is already constrained to `[0, 1]`, and satisfies SafeStan's unique-prior requirement. The likelihood remains `y ~ binomial(K, theta)`.

Deterministic data relation: `y_safestan_copy[n] = y[n]` for every `n = 1, ..., N`.
