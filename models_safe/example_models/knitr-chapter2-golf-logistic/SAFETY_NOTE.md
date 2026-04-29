# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is a plain top-level sampling statement, `y ~ binomial_logit(n, a + b * x)`, so `y` is the protected interface variable. However, parameters `a` and `b` are used in that likelihood without any prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for unconstrained real parameters `a` and `b` would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite.
