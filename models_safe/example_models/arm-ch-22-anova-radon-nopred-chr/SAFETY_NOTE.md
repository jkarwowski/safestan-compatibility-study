# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `sigma_a ~ uniform(0, 100)` and `sigma_y ~ uniform(0, 100)` sampling statements. These match the existing finite bounds on the parameters and make the implicit bounded uniform priors explicit for SafeStan's unique-prior requirement. No data changes were required.
