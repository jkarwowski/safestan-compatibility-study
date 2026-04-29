# SafeStan Safety Note

Compatibility: major.

Protected data: `log_lik` is the data-dependent quantity entering the manual likelihood score.

Generated files: none.

Reason: the model uses `target += log_sum_exp(lp)` inside a loop to add a marginalized latent-state likelihood based on a precomputed log-likelihood table. SafeStan forbids arbitrary `target +=` scoring, and replacing this computation with built-in sampling statements would require a substantive model rewrite or a different observation model rather than a minor same-density translation. The parameter prior `state_prob ~ dirichlet(prior_concentration)` is compatible, but the marginal likelihood path is not.
