# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the prior sampling statements in the `model` block so that `lambda` and `tau` are given their built-in priors before they are used in the prior for `theta_cp`. This is a same-density mechanical reordering of additive Stan log-density terms. The protected likelihood statement `y ~ normal(theta[context_idx], sigma)` is unchanged. No data fields were added or changed.
