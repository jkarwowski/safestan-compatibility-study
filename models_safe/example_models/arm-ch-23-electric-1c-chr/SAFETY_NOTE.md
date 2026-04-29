# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `sigma_a ~ uniform(0, 100)` and `sigma_y ~ uniform(0, 100)` prior sampling statements. These correspond to the existing finite bounds on `sigma_a` and `sigma_y` and make the implicit proper uniform priors explicit for SafeStan's unique-prior requirement. No data fields were added or changed. The protected observation `y` remains a top-level data variable and is observed exactly once with a built-in distribution.
