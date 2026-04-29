# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a`, `sigma_b`, and `sigma_y`, matching their finite parameter bounds. These priors make the existing implicit bounded-uniform assumptions explicit and satisfy SafeStan's requirement that every parameter have exactly one built-in prior sampling statement before use. No data changes were required.
