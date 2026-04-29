# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. All parameters have one built-in prior sampling statement before their use in the likelihood. Other data variables (`N`, `N_cov`, `w`, `x`, and `xw_inter`) are context inputs used as dimensions or predictors and are not protected.
