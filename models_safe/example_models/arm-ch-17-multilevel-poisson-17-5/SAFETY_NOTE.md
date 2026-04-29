# SafeStan Safety Note

Compatibility: minor.

Protected data: `stops`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic assignment to `mu_adj` until after the priors for `b_eth` and `b_precint`. In the original program, that assignment read `b_eth` and `b_precint` before their sampling statements, which violates SafeStan's parameter-use discipline. The assignment is deterministic and unused in the likelihood, so this reordering preserves the posterior/log density. No data fields were changed or added.
