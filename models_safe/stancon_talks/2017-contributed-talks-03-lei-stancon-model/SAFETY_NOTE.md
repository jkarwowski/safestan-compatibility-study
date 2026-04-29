# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because protected data cannot be referenced in `transformed data` before its sampling statement. The transformed-data computation of `logit_mean_y` now uses this copy, preserving the original density when `y_safestan_copy = y`. The matrix parameters `v_ad_platform_g`, `v_ad_platform_sigma_g`, and `v_ad_platform_film` were changed to two-dimensional real arrays so their priors can be written as plain top-level parameter sampling statements rather than `to_vector(...) ~ ...`; indexing and the elementwise prior densities are unchanged.

Data augmentation: `y_safestan_copy` is exactly the supplied `y` array.
