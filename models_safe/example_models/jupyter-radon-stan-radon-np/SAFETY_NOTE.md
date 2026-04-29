# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter priors for `alpha`, `beta`, and `sigma` appear before the likelihood statement that uses them. This preserves the same posterior density while satisfying SafeStan's requirement that each parameter be sampled from its prior before any model-block use. No data changes were required.
