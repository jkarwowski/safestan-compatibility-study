# SafeStan Safety Note

Compatibility: major.

Protected data: `counts`.

Generated files: none.

Reason: the likelihood for `counts` is a marginalized Poisson change-point model implemented with manual `target += log_sum_exp(lp_change)` scoring, where each possible change point contributes a full Poisson likelihood over the indexed observations. SafeStan forbids arbitrary `target +=` scoring and requires each protected data variable to be observed exactly once with a built-in sampling statement. Replacing this marginalized finite-state likelihood with SafeStan sampling statements would require a substantive model rewrite rather than a minor same-density translation.
