# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: vectorized the row-wise priors for `eta_c` and `eta_d` so each top-level matrix parameter is sampled exactly once outside a loop. Added explicit `uniform(0, 100)` priors for the finite-bounded scale parameters `sigma_a1`, `sigma_a2`, `sigma_b1`, `sigma_b2`, `sigma_c`, `sigma_d`, and `sigma_y`; these match the original implicit proper uniform priors induced by their `<lower=0, upper=100>` constraints, preserving the posterior up to a constant. No data changes were required.
