# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `sigma_a ~ uniform(0, 100);` and `sigma_y ~ uniform(0, 100);` prior statements. These match the implicit proper uniform priors for the finite-bounded parameters and satisfy SafeStan's requirement that every parameter have exactly one built-in prior before use. The protected likelihood `y ~ normal(y_hat, sigma_y);` is unchanged, and no data changes were required.
