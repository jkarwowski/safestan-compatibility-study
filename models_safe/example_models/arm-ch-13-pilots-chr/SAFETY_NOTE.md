# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a`, `sigma_b`, and `sigma_y`. These parameters were already finite-bounded real parameters, so the added priors make the implicit bounded-uniform prior discipline explicit for SafeStan. The protected observation `y` is already a top-level data variable and is observed exactly once with a built-in distribution. The data file is unchanged.
