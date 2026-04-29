# SafeStan Safety Note

Compatibility: minor.

Protected data: `grade_obs`, the observed non-missing entries of the original `grade` array in row-major order.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the manual `target += log(p[i, j, grade[i, j]])` likelihood and the missingness gate `if (grade[i, j] != -1)` with a single built-in `categorical` sampling statement on `grade_obs`. The original `grade` array is reshaped deterministically into `N_obs`, `n_obs_child`, `obs_ind`, and `grade_obs`: `N_obs` is the number of original entries with `grade != -1`; `n_obs_child[i]` is the number of observed grades for child `i`; `obs_ind` lists the indicator index for each observed entry in row-major order; and `grade_obs` lists the corresponding observed grade value. Missingness/locations are treated as context, while the observed grade values are protected. The prior `theta ~ normal(0.0, 36)` was already a valid built-in prior, so no prior change was needed.
