# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in uniform priors for `sigma_a`, `sigma_b`, and `sigma_y`. These parameters already had finite bounds `[0, 100]` in the original Stan program, so the added `uniform(0, 100)` statements make the implicit bounded uniform priors explicit for SafeStan's unique-prior requirement. No data changes were made.
