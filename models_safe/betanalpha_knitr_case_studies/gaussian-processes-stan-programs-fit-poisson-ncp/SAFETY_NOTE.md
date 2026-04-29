# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y_obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level data variable `y_obs`, which is observed exactly once with the built-in `poisson_log` distribution. The parameter `f_tilde` is given exactly one built-in prior before its transformed-parameter-dependent value `f_predict` is used in the likelihood. Other data variables are context inputs used only for dimensions, indexing, and covariance construction.
