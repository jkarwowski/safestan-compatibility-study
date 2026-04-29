# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter prior `theta ~ normal(mu_0, sigma_0)` appears before the likelihood `y ~ normal(theta, sigma_y)`. This preserves the same posterior/log density while satisfying SafeStan's rule that a parameter must be given its unique built-in prior before it is used. No data changes were required.
