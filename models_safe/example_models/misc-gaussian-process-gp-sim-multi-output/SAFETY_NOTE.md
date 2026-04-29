# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The top-level data variables `N`, `D`, and `x` are context inputs only; no top-level data variable appears on the left side of a sampling statement.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter sampling statements for `L_Omega` and `eta` so they occur before those parameters are used to construct `f`. Replaced `to_vector(eta) ~ normal(0, 1)` with the equivalent elementwise matrix statement `eta ~ normal(0, 1)`, and replaced `to_vector(y) ~ normal(to_vector(f), sigma)` with the equivalent elementwise matrix statement `y ~ normal(f, sigma)`, so sampling targets are top-level parameters. No data changes were required.
