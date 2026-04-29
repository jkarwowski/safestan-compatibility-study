# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed series `y` is scored by the built-in `gaussian_dlm_obs` likelihood, but both parameters (`sigma_y` and `sigma_theta`) are positive-constrained parameters with no explicit prior. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors would change the posterior/log density, while the original implicit priors are improper uniforms on `(0, infinity)` and cannot be represented as a density-preserving SafeStan prior statement. Therefore this model cannot be translated without a substantive density change.
