# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the parameter prior statements so `lambda` is sampled with its built-in Cauchy prior before it is used in the scale of the `theta` prior. This preserves the same log density because Stan sampling statements contribute additively. The observation model `y ~ normal(theta[context_idx], sigma)` is unchanged; `K`, `N`, `context_idx`, `tau`, and `sigma` are context inputs and are not protected.
