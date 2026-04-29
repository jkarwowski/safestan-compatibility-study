# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 100)` prior sampling statements for `sigma_a` and `sigma_y`, which were already finite-bounded parameters and therefore had implicit proper uniform priors on `[0, 100]`. These priors are placed before any model-block use of the corresponding parameters. The observation model remains `y ~ normal(y_hat, sigma_y)`, with `y` scored exactly once as a top-level protected data variable. No data changes were required.
