# SafeStan Safety Note

Compatibility: minor.

Protected data: `chosen_action`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the parameter prior before any model-block use of `beta` by inlining the deterministic `logits = beta * utility` expression in the observation statement. This preserves the same log density while satisfying SafeStan's requirement that each parameter be sampled from its prior before use. No data changes were required.
