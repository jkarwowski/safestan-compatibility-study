# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a`, `sigma_b`, `sigma_beta`, and `sigma_y`. These parameters were already finitely constrained to `[0, 100]`, so the added statements make the implicit proper uniform priors explicit for SafeStan's unique-prior discipline without changing the posterior density. No data changes were required; `N`, `county`, `u`, and `x` remain unprotected context inputs.
