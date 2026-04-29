# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `sigma_y ~ uniform(0, 2.5);` before `sigma_y` is used in the likelihood. This is a density-neutral explicit prior for the existing finite-bounded parameter `real<lower=0, upper=2.5> sigma_y`, satisfying SafeStan's requirement that each parameter have exactly one built-in prior sampling statement before use. No data changes were required. `N` and `movie` remain unprotected context inputs.
