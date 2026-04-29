# SafeStan Safety Note

Compatibility: major.

Protected data: `num_students`.

Generated files: none.

Reason: the observed likelihood is `num_students ~ poisson_log(theta)`, so `num_students` is the protected interface variable. Some parameter-prior syntax issues, such as looped/projection priors for `alpha_grade`, `alpha_year`, and `alpha_cohort`, could be mechanically vectorized. However, `tau_year`, `tau_grade`, `tau_cohort`, and `sigma` are positive parameters with no explicit prior sampling statement. SafeStan requires every parameter to have exactly one built-in prior before use. Adding half-normal, exponential, or other proper priors would change the posterior/log density, and the original implicit half-flat priors on `[0, infinity)` cannot be represented by a SafeStan-compatible built-in proper prior without a substantive density change.
