# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic top-level data copy of `y`, and used it for the transformed-data summary statistics because protected data cannot be read in `transformed data` before being observed. Added `phi ~ uniform(0, 1)`, which is density-neutral for the existing `real<lower=0, upper=1>` parameter and satisfies SafeStan's unique-prior requirement. The posterior-predictive inputs `K_new` and `y_new` remain ordinary context data; they are not conditioned on in the model block.
