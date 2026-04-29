# SafeStan Safety Note

Compatibility: major.

Protected data: candidate protected observations are `mu`, which is scored by `mu ~ normal(0, 10)`, and `y`, which is scored inside the marginalized mixture likelihood.

Generated files: none.

Reason: the likelihood for `y` is implemented through manual `target += log_sum_exp(ps)` scoring, where `ps` contains `normal_lpdf(y[n] | mu[k], sigma)` terms. SafeStan forbids `target +=` and requires protected observations to be scored exactly once using built-in sampling statements with a plain top-level data variable on the left-hand side. There is no built-in Stan distribution corresponding to this finite normal mixture likelihood, and replacing the marginalized mixture with latent allocations or another formulation would be a substantive model rewrite. Therefore no same-density minor SafeStan translation is produced.
