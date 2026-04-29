# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model observes `y` with a built-in likelihood, `y ~ normal(a + b * x, sigma_y)`, while `x` and `N` are context inputs. However, the parameters `a`, `b`, and `sigma_y` have no prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before it is used. Adding proper priors would change the posterior/log density, and the existing implicit flat/improper priors cannot be represented as SafeStan-compliant proper built-in priors by a minor same-density rewrite.
