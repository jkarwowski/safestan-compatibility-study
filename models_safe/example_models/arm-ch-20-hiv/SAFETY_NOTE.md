# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a1`, `sigma_a2`, and `sigma_y`, which are already finite-bounded parameters and therefore have the corresponding implicit proper uniform support in the original model. The prior statements are placed before any use of these parameters. No data changes were required.
