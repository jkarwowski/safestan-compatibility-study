# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: `y` is the observed relational outcome scored inside a marginalized finite-cluster mixture likelihood. The likelihood is implemented with `bernoulli_lpmf(y[n] | cluster_prob[k])` inside `target += log_sum_exp(lp)`. SafeStan forbids manual `target +=` scoring, and replacing this marginalized mixture with plain SafeStan sampling statements would require a substantive model rewrite, such as introducing latent cluster assignments or otherwise changing the likelihood representation. Therefore no minor same-density SafeStan translation is produced.
