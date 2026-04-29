# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a1`, `sigma_a2`, and `sigma_y`. These parameters already had finite bounds `real<lower=0, upper=100>`, so the added built-in uniform sampling statements are density-neutral for the original constrained-parameter model and satisfy SafeStan's unique-prior requirement. No data changes were required.
