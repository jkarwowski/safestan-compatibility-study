# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation likelihood for `y` is a marginalized finite Gaussian mixture implemented with manual `target += log_sum_exp(...)` scoring and calls to `normal_lpdf`. SafeStan forbids arbitrary `target +=` scoring, and replacing this marginalized mixture likelihood with SafeStan sampling statements would require a substantive model rewrite rather than a minor same-density translation.
