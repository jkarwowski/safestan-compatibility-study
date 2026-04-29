# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` priors for `sigma_eta` and `sigma_y`. These parameters already have finite bounds `<lower=0, upper=100>`, so the added priors make the implicit proper uniform priors explicit and satisfy SafeStan's unique-prior requirement. No data changes were made; `J`, `N`, and `county` are unprotected context inputs.
