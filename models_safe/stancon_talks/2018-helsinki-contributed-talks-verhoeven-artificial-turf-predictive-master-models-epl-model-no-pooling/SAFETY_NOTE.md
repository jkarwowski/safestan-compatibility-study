# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the parameter prior statement `to_vector(eta_a) ~ normal(0,1)` with a top-level vector parameter `eta_a_vec ~ normal(0, 1)` and a deterministic transformed-parameter matrix `eta_a = to_matrix(eta_a_vec, n_weeks, n_teams)`. This is a same-density mechanical rewrite of the original independent standard-normal prior over all entries of `eta_a`, needed because SafeStan sampling statements must target top-level variables rather than expressions. No data fields were added or changed.
