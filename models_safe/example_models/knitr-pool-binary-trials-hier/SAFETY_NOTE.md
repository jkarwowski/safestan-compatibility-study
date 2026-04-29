# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because the original program read `y` in `transformed data` before the likelihood statement. The transformed-data summaries now use this copy. Added `phi ~ uniform(0, 1)`, which is density-neutral for the existing parameter constraint `real<lower=0, upper=1> phi` and satisfies SafeStan's unique-prior requirement. `N`, `K`, `K_new`, and `y_new` are context data; `y_new` is used only in generated quantities and is not conditioned on in the model block.

Deterministic data augmentation: `y_safestan_copy` is exactly equal to `y` elementwise.
