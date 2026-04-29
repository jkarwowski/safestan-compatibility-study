# SafeStan Safety Note

Compatibility: minor.

Protected data: `x1`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the model-block deterministic computations of `sigma_sq`, `tau1_sq`, and `sum_sq_1` to occur after the prior sampling statements. In the original program these local initializers used parameters before their required SafeStan priors. The rewrite preserves the same posterior/log density. No data changes were required.
