# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model-block sampling statements so that hyperparameters (`mu_alpha`, `sigma_alpha`, `mu_beta`, `sigma_beta`) receive their priors before they are used in the priors for `alpha` and `beta`. This preserves the same posterior/log density because Stan sampling statements add commutatively to the log density. The data file is unchanged.
