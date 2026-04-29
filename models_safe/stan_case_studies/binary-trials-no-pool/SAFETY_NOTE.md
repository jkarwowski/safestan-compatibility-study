# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic top-level data copy with `y_safestan_copy[n] = y[n]` for all `n`, and used it for transformed-data and generated-quantities summaries so the protected variable `y` is not read before its likelihood statement. Added `theta ~ uniform(0, 1)`, which is density-neutral for the existing `vector<lower=0, upper=1>[N]` parameter and satisfies SafeStan's unique-prior requirement. `K`, `K_new`, and `y_new` remain context data; `y_new` is only used in generated quantities and is not part of the model target density.
