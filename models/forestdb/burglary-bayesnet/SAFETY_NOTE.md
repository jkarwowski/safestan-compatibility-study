# SafeStan Safety Note

Compatibility: major.

Protected data: `calls`.

Generated files: none.

Reason: the likelihood for the observed calls is implemented by manual `bernoulli_lpmf(...)` terms inside a marginalization over hidden burglary, earthquake, and alarm states, followed by `target += log_sum_exp(lp)`. Replacing this marginalized latent-state calculation with SafeStan plain sampling statements would require a substantive model/density rewrite rather than a small mechanical translation. The remaining data variables are fixed probability-table inputs and are not themselves scored as observations.
