# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in `uniform(0, 100)` priors for the finite-bounded scale parameters `sigma_a` and `sigma_y`, matching their existing constrained implicit uniform priors and satisfying SafeStan's requirement that every parameter have exactly one prior sampling statement before use. The prior statements were ordered so that parameters are not used before their priors. No data changes were made; `J`, `N`, `county`, `u`, `x`, and `x_mean` remain context inputs.
