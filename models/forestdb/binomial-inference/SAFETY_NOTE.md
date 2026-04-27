# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: removed the generated quantity `log_lik = binomial_lpmf(y | N, theta)` because it directly evaluated an `_lpmf` on the protected observation. This generated quantity does not contribute to the Stan target density, so removing it preserves the posterior/log density. The prior, likelihood, posterior predictive draw `y_rep`, and data are otherwise unchanged.
