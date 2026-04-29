# SafeStan Safety Note

Compatibility: minor.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that each parameter receives its built-in prior before any model-block use in the nonlinear mean or likelihood. The likelihood `Y ~ normal(m, sigma)` is unchanged and remains the single observation of the protected top-level data variable `Y`. Context inputs `N` and `x` are not protected because they are sizes/predictors and are not scored as observations. No data changes were required.
