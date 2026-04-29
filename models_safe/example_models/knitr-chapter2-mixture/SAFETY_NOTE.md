# SafeStan Safety Note

Compatibility: major.

Protected data: the original model scores `mu` with `mu ~ normal(0, 10)` and scores `y` through a marginalized mixture likelihood.

Generated files: none.

Reason: the likelihood for `y` is implemented by manually accumulating `target += log_sum_exp(ps)`, where `ps` contains component log densities `normal_lpdf(y[n] | mu[k], sigma)` plus mixture weights. SafeStan forbids manual `target +=` scoring and `_lpdf` calls, and there is no built-in Stan sampling statement for this marginalized finite mixture. Replacing it would require a substantive latent-mixture/model rewrite rather than a minor same-density translation.
