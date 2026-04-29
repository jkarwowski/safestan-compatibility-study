# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in `uniform(0, 100)` priors for `sigma_a1`, `sigma_a2`, and `sigma_y`. These parameters were already constrained to `[0, 100]`, so the added sampling statements make the implicit bounded uniform priors explicit and satisfy SafeStan's unique-prior requirement without changing the posterior density. No data changes were required.
