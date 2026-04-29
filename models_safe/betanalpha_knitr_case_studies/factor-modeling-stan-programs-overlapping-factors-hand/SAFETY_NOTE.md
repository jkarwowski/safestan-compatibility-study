# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that every parameter prior appears before any use of that parameter. In particular, the local predictor `theta` is declared first but assigned only after all priors, and each scale parameter prior is placed before the corresponding factor-effect prior that uses it. The likelihood for protected data remains the single built-in statement `y ~ normal(theta, sigma)`. No data values were changed.
