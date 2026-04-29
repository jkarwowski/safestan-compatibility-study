# SafeStan Safety Note

Compatibility: major.

Protected data: `price` and `sales` in the original model.

Generated files: none.

Reason: the model scores transformed/indexed observations inside loops: `log(to_vector(price')[i]) ~ normal(...)` and `sales[t] ~ multinomial(...)`. Making `sales` SafeStan-compatible might be a mechanical vectorization, but preserving the price likelihood exactly would require introducing a new protected top-level observation equal to `log(price)` or changing the likelihood to a lognormal likelihood for `price`. The former is a deterministic transformed observation rather than a copy/reshape of the supplied data interface, and the latter changes the normalized log density by the log-Jacobian term. Therefore an exact SafeStan translation cannot be produced with only minor same-density rewrites.
