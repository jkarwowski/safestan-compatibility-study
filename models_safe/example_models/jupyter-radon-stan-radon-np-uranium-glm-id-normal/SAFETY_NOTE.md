# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter priors for `alpha`, `beta`, and `sigma` appear before the likelihood statement. This preserves the same posterior/log density because Stan sampling statements add commutative log-density terms. No data fields were added or changed. Context data `N`, `J`, `county`, `x`, and `u` are not protected; they are used only as sizes, indices, or predictors.
