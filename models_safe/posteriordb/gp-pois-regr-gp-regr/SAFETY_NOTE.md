# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model computed the Gaussian-process covariance using parameters `alpha`, `rho`, and `sigma` before their prior sampling statements. SafeStan requires each parameter to be observed with its unique prior before any model-block use. The rewritten model declares the local matrices first, then applies the three existing built-in priors, then computes the covariance and scores `y` with the same `multi_normal_cholesky` likelihood. No data changes were required.
