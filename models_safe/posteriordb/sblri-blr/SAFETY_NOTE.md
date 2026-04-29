# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the three manual `target += normal_lpdf(...)` terms with equivalent built-in sampling statements. The parameter priors are now written as `beta ~ normal(0, 10)` and `sigma ~ normal(0, 10)`, and the likelihood is written as `y ~ normal(X * beta, sigma)`. This preserves the Stan log density while satisfying SafeStan's restrictions against arbitrary `target +=` scoring. The data file is unchanged.
