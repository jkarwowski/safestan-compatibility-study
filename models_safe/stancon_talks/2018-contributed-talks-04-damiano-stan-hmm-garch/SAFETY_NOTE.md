# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observation series `y` is scored through a marginalized HMM-GARCH likelihood computed with `normal_lpdf(...)` calls in `transformed parameters` and then added with `target += log_sum_exp(log_alpha[T])`. SafeStan forbids manual `target +=` scoring and `_lpdf` likelihood construction, and protected data cannot be used in transformed parameters before a plain built-in sampling statement. Replacing this recursive marginalized likelihood with SafeStan-compatible sampling statements would require a substantive model rewrite/change rather than a minor same-density translation.
