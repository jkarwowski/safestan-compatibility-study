# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the original likelihood observes the top-level data variable `y` with `y ~ normal(y_hat, sigma_y)`, so `y` is the protected interface. However, the model has scale parameters `sigma_a1`, `sigma_a2`, and `sigma_y` declared with only lower bounds and no explicit priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these scale parameters would change the posterior/log density; the original implicit improper flat priors on positive reals are not a minor density-preserving rewrite. Additionally, `sigma_a1` and `sigma_a2` are used in other parameter priors before any prior of their own. Therefore no SafeStan-compatible version can be produced without a substantive density change.
