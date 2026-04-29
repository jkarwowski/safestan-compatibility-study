# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ normal(y_hat, sigma_y)`, so `y` is the protected interface and is already a top-level plain observation. However, SafeStan requires every parameter to have exactly one built-in prior before use. This model leaves `mu` with an implicit improper flat prior (`// mu ~ unif(-inf, +inf); // implicit`). Adding any proper built-in prior for `mu` would change the posterior/log density, and there is no SafeStan-compatible built-in sampling statement that exactly represents the same improper prior. The bounded scale parameters could receive density-neutral explicit `uniform(0, 100)` priors, but `mu` prevents a same-density minor rewrite.
