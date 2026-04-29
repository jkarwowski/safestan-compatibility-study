# SafeStan Safety Note

Compatibility: minor.

Protected data: `x1_sim` (reshaped as a vector equal to Stan `to_vector` of the original `matrix[N_node, N_time] x1_sim`).

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reshaped `x1_sim` in `data_safe.json` to `[original_x1_sim[1, 1], ..., original_x1_sim[N_node, 1], original_x1_sim[1, 2], ...]`, i.e. Stan column-major order, so the likelihood can score the protected data once with a plain top-level sampling statement. Reordered the three parameter priors before any model-block use of those parameters, and vectorized the elementwise `x0` prior. Replaced the nested indexed likelihood with `x1_sim ~ normal(to_vector(x1), 1.0)`, preserving the same product of normal densities.
