# SafeStan Safety Note

Compatibility: minor.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so the parameter prior `eps ~ normal(0, sigma)` appears before the likelihood `C ~ poisson_log(log_lambda)`. This is density-preserving because Stan sampling statements add log-density terms commutatively, and it satisfies SafeStan's requirement that parameters be sampled before they are used through transformed parameters such as `log_lambda`.

No data changes were required. `year` and `n` are context inputs and are not protected.
