# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood conditions on the observed response array `y` using indexed sampling statements inside a loop (`y[i] ~ bernoulli_logit(...)`), which would require a mechanical vectorization/reshape to satisfy SafeStan's protected-data syntax. More importantly, the model has unconstrained parameters `b_raw` and `theta_raw` with no explicit built-in prior sampling statements; their original priors are implicit improper flat densities. SafeStan requires each parameter to have exactly one built-in prior before use, and adding proper priors would change the posterior/log density. Therefore no SafeStan-compatible translation preserving the original density is available as a minor rewrite.
