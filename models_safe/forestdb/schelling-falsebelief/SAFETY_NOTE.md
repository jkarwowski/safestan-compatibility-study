# SafeStan Safety Note

Compatibility: minor.

Protected data: `chosen_action`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the computation of the categorical-logit linear predictor to the likelihood statement after the prior on `beta`. This preserves the same posterior/log density while satisfying SafeStan's requirement that each parameter receive its prior before being used in the model block. No data changes were required.
