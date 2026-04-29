# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a1`, `sigma_a2`, and `sigma_y`. These parameters already have finite bounds `<lower=0, upper=100>`, so the added statements make the existing implicit bounded uniform priors explicit for SafeStan's unique-prior requirement. No data changes were required.
