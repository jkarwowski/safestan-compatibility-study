# SafeStan Safety Note

Compatibility: major.

Protected data: `pos_tests`.

Generated files: none.

Reason: the observed binomial likelihood is on the top-level data variable `pos_tests`, but the model also contains soft sum-to-zero prior factors written as sampling statements on parameter expressions: `sum(beta_age) ~ normal(...)`, `sum(beta_eth) ~ normal(...)`, and `sum(beta_edu) ~ normal(...)`. SafeStan only allows sampling statements whose left side is a protected top-level data variable or a top-level parameter, and each parameter must have exactly one prior sampling statement. Preserving these additional expression-level prior factors would require either arbitrary log-density adjustment or adding new pseudo-observations, which is not a minor deterministic copy/reshape of the supplied data.
