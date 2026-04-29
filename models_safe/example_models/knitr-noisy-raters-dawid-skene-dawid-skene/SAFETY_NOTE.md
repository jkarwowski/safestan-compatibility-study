# SafeStan Safety Note

Compatibility: major.

Protected data choice: the observed rater labels are `y` in the original model.

Generated files: none.

Reason: the likelihood for `y` is a marginalized Dawid-Skene latent-class likelihood implemented with manual `target += log_sum_exp(log_q)` scoring inside a loop. SafeStan forbids arbitrary `target +=` scoring, and there is no direct built-in Stan sampling distribution for the observed rating matrix with the latent item categories marginalized out. Replacing this with a SafeStan-compatible construction would require a substantive likelihood/algorithm rewrite rather than a minor mechanical translation.
