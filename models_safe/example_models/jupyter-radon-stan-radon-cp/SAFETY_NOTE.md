# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that each parameter (`alpha`, `beta`, and `sigma`) receives its built-in prior sampling statement before being used in the likelihood for the protected observation `y`. The posterior/log density is otherwise unchanged. No data fields were added or changed; `x` remains an unprotected context predictor and `N` remains a size input.
