# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is implemented with manual `target += log_sum_exp(ps)` scoring after marginalizing over latent classes. SafeStan forbids direct `target +=` likelihood manipulation, and replacing this marginalized latent-class likelihood with built-in sampling statements would require a substantive model rewrite rather than a minor same-density translation. The model also has an implicit bounded uniform prior for `eta`, which could be made explicit mechanically, but the manual marginalized likelihood is the blocking issue.
