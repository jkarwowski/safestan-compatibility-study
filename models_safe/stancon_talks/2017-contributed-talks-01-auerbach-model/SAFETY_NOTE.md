# SafeStan Safety Note

Compatibility: minor.

Protected data: `count_train`, a deterministic copy of the first `N_train` entries of the original `count` array.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added top-level data variable `count_train`; in `data_safe.json`, `count_train = count[1:N_train]` (`[5]` for the supplied data). Replaced the manual loop with `target += poisson_log_lpmf(...)` and the zero-truncation normalizing adjustment by the equivalent vectorized built-in sampling statement `count_train ~ poisson_log(mu_indiv) T[1, ];`. Other data variables are context inputs used as predictors, indices, sizes, or exposure values. Existing parameter priors were already explicit built-in sampling statements.
