# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized mixture over a global linear-versus-quadratic model indicator, implemented with manual `normal_lpdf` accumulation and `target += log_sum_exp(...)`. Representing this same density under SafeStan plain sampling-statement rules would require a substantive rewrite such as introducing a latent model indicator or a custom/user-defined mixture distribution, which is not a minor same-density translation.
