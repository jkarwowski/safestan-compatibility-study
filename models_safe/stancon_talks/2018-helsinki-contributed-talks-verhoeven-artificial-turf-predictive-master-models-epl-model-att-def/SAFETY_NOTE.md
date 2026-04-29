# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the two matrix standard-normal priors from `to_vector(eta_a_offense) ~ normal(0, 1)` and `to_vector(eta_a_defense) ~ normal(0, 1)` to plain top-level parameter sampling statements, `eta_a_offense ~ normal(0, 1)` and `eta_a_defense ~ normal(0, 1)`. This is the same Stan vectorized density over all matrix elements, but satisfies SafeStan's requirement that parameter priors target top-level parameter variables. The data are unchanged.
