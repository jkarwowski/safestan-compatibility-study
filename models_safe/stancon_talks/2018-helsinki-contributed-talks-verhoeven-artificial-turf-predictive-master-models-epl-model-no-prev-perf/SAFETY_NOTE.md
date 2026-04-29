# SafeStan Safety Note

Compatibility: minor.

Protected data: `goal_difference`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the likelihood observation `goal_difference` is already a top-level data variable and is scored exactly once with the built-in `student_t` distribution. The only rewrite is for the matrix parameter `eta_a`: the original prior was written as `to_vector(eta_a) ~ normal(0, 1)`, whose left-hand side is not a top-level parameter identifier. The safe model declares a top-level vector parameter `eta_a_vec`, gives it the same independent standard normal prior, and deterministically reshapes it to the matrix `eta_a` in `transformed parameters` using `to_matrix`. This is a one-to-one unit-Jacobian reparameterization and preserves the posterior/log density. The data are unchanged.
