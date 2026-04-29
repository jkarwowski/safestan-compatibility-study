# SafeStan Safety Note

Compatibility: major.

Protected data: the original model observes/scores `bsize` and `y`. `bsize` is scored with a truncated normal sampling statement, and `y` is scored through manual marginalized capture-history likelihood terms.

Generated files: none.

Reason: the capture-history likelihood for `y` is implemented with `target +=`, `log_sum_exp(...)`, and data-dependent branching on `s[i] = sum(y[i])` to marginalize over the latent inclusion state. SafeStan forbids manual `target +=` scoring, and replacing this marginalized zero-inflated/latent-state likelihood with built-in sampling statements would require a substantive model rewrite rather than a minor same-density translation. Other issues such as indexed observation of `bsize`, pre-observation use of `y` in `transformed data`, and implicit bounded-uniform priors would be mechanically fixable, but the marginalized `target +=` likelihood is not.
