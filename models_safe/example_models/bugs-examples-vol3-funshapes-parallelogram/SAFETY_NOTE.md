# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The model has no data block and no observed likelihood terms.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added explicit `uniform(0, 1)` priors for the bounded parameters `x` and `y_raw`. These match the implicit density induced by their finite constraints and add zero log density on the constrained support, while satisfying SafeStan's requirement that each parameter have exactly one built-in prior sampling statement.
