# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `sigma_a ~ uniform(0, 100)` and `sigma_y ~ uniform(0, 100)` statements so the finite bounded scale parameters have exactly one built-in SafeStan prior before use. These make the original implicit proper uniform priors from `real<lower=0, upper=100>` explicit. No data fields were added or changed; `J`, `N`, `county`, and `u` are unprotected context inputs.
