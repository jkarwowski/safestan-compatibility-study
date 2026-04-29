# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a` and `sigma_y`. These parameters were already constrained to `[0, 100]`, so the added priors match the implicit bounded-support prior up to a constant and satisfy SafeStan's requirement that every parameter have exactly one built-in prior before use. No data changes were required.
