# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter priors for `a`, `b`, and `sigma` appear before the likelihood. This preserves the same posterior/log density because Stan sampling statements add commutative log-density terms, and it satisfies SafeStan's requirement that parameters be given their priors before use in the model block. The data file is unchanged.
