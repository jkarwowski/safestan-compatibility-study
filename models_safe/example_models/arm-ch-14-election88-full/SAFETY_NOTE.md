# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit built-in `uniform(0, 100)` priors for `sigma_a`, `sigma_b`, `sigma_c`, `sigma_d`, and `sigma_e` before those parameters are used as prior scales. These parameters were already constrained to `[0, 100]`, so the explicit uniform statements make the implicit bounded-support priors explicit for SafeStan while preserving the posterior. No data fields were added or changed.
