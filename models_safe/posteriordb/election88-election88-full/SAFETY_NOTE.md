# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_a`, `sigma_b`, `sigma_c`, `sigma_d`, and `sigma_e`. These parameters were already constrained to `[0, 100]`, so the added statements make the existing implicit bounded-uniform priors explicit and allow the scale parameters to be used safely in later normal priors. No likelihood or data transformation was changed; `data_safe.json` should be identical to the supplied data file.
