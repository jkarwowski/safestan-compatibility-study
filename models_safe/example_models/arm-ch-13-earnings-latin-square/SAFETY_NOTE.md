# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for the bounded scale parameters `sigma_a1`, `sigma_a2`, `sigma_b1`, `sigma_b2`, `sigma_c`, `sigma_d`, and `sigma_y`, matching their finite parameter constraints and satisfying SafeStan's unique-prior requirement. Replaced the looped row-wise priors for `c` and `d` with equivalent vectorized sampling statements on the top-level matrix parameters, because SafeStan does not allow parameter-prior sampling statements inside loops. No data changes were required.
