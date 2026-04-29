# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: rewrote the prior for the random-component matrix so that the sampling statement has a plain top-level parameter on the left-hand side. The original `matrix[n_weeks,n_teams] eta_a` parameter with `to_vector(eta_a) ~ normal(0,1)` was replaced by a top-level vector parameter `eta_a_vec ~ normal(0,1)` and a deterministic transformed-parameter matrix `eta_a = to_matrix(eta_a_vec, n_weeks, n_teams)`. This is a unit-Jacobian reshape with the same iid standard normal density for the matrix entries. No data fields were added or changed.
