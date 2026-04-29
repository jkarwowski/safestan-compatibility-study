# SafeStan Safety Note

Compatibility: major.

Protected data: the model scores the uncensored event times `t_uc` with a Weibull likelihood and also includes a parameter-dependent right-censoring likelihood for the censored times `t_rc`.

Generated files: none.

Reason: the `t_uc` likelihood and the random-effect prior loops could be mechanically vectorized, but the censored-time contribution is implemented as `1 ~ bernoulli(exp(-pow(... t_rc[i] ...)))`, i.e. a survival likelihood contribution using a constant left-hand side and the observed censored time inside the probability. SafeStan sampling statements must target protected top-level data or parameters with built-in distributions, and this censored Weibull survival term cannot be rewritten as a built-in sampling statement on `t_rc` without changing the density. Externalizing the literal `1` as new Bernoulli data would also change the protected interface rather than scoring the censored times. Therefore a SafeStan-compatible version would require a substantive likelihood/interface rewrite.
