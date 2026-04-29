# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a` and `sigma_y`. These parameters were already constrained to `[0, 100]`, so the added priors make the implicit bounded uniform priors explicit for SafeStan without changing the posterior except for a constant log-density offset. The protected observation `y` is a top-level data variable and is observed exactly once with the built-in `normal` distribution. No data changes were required.
