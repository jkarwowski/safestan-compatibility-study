# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y`.

Generated files: none.

Reason: the likelihood itself is a SafeStan-style built-in sampling statement, `y ~ normal(X * b, sigma)`, with `X`, `N`, and `K` as context data. However, the parameters `b` and `sigma` have no explicit prior sampling statements before they are used in the likelihood. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for `b` or `sigma` would change the posterior/log density; the original model relies on implicit improper flat priors, which cannot be represented as a minor SafeStan rewrite.
