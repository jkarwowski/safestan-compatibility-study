# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model conditions on the count array `y` through a marginalized binomial-Poisson mixture likelihood implemented with manual `target += log_sum_exp(...)` scoring. SafeStan forbids `target +=`, and replacing this calculation with SafeStan sampling statements would require a substantive change to the marginal latent-population likelihood rather than a minor mechanical rewrite. The model also uses `y` in `transformed data` to compute `max_y` before any possible protected-data observation, but even a deterministic copy would not address the manual marginalized likelihood.
