# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` prior sampling statements for `sigma_a` and `sigma_y`, which are already finite-bounded parameters in the original model. The priors are placed before those parameters are used, satisfying SafeStan's unique-prior and before-use requirements. No data changes were required.
