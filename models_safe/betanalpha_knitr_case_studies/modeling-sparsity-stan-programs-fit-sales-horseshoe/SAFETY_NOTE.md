# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the observation model already scores the top-level protected data variable `y_obs` exactly once with a built-in distribution. The prior for `delta_days_tilde` was rewritten from an elementwise sampling statement inside a loop to one vectorized top-level sampling statement, and the hyperpriors for `lambda` and `tau_day` were moved before the dependent `delta_days_tilde` prior. These are mechanical same-density changes that preserve the posterior density while satisfying SafeStan's parameter-prior ordering and top-level sampling requirements. No data fields were added or changed.
