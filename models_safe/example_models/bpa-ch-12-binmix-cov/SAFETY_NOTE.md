# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model conditions on `y` through a marginalized binomial-mixture likelihood implemented with manual `target += log_sum_exp(...)` scoring over the latent population size. SafeStan forbids arbitrary `target +=` scoring and requires each protected observation to be scored exactly once by a built-in sampling statement. Replacing this marginal likelihood with SafeStan sampling statements would require a substantive model rewrite, such as changing the marginalized latent-state algorithm or introducing a different likelihood representation. The model also uses `y` in `transformed data` to compute `max_y` before observation, which would need restructuring, but the primary blocker is the non-built-in marginalized likelihood.
