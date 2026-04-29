# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the three forbidden `target += normal_lpdf(...)` statements with equivalent built-in Stan sampling statements. The parameter priors are now written as `beta ~ normal(0, 10);` and `sigma ~ normal(0, 10);`, satisfying SafeStan's unique-prior requirement before parameter use. The likelihood is now written as `y ~ normal(X * beta, sigma);`, with protected data `y` observed exactly once as a plain top-level data variable. No data changes were required.
