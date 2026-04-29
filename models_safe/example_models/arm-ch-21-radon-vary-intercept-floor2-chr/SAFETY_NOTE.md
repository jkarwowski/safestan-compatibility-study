# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a` and `sigma_y`. These parameters already had finite bounds `<lower=0, upper=100>` and no explicit prior, so the added statements make the implicit bounded-uniform prior explicit for SafeStan's unique-prior requirement without changing the posterior apart from a parameter-independent normalizing constant. No data changes were required.
