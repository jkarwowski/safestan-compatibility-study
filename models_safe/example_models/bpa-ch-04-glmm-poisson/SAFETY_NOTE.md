# SafeStan Safety Note

Compatibility: minor.

Protected data: `C`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved `eps ~ normal(0, sigma)` before `C ~ poisson_log(log_lambda)`. Since `log_lambda` depends on `eps`, SafeStan requires the `eps` prior before the likelihood uses `log_lambda`; reordering additive Stan sampling statements preserves the posterior/log density. No data changes; `n` and `year` remain context inputs.
