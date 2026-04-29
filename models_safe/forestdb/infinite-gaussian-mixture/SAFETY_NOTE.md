# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model conditions on `y` through a marginalized finite approximation to a Gaussian mixture likelihood implemented with manual `target += log_sum_exp(...)` scoring and explicit `normal_lpdf(...)` calls. SafeStan forbids arbitrary `target +=` likelihood construction, and replacing this marginalized mixture with SafeStan sampling statements would require a substantive model rewrite or a different likelihood representation rather than a minor mechanical same-density translation.
