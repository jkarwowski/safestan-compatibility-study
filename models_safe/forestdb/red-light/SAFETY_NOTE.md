# SafeStan Safety Note

Compatibility: minor.

Protected data: `chosen_action`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the prior statement `beta ~ lognormal(0, 0.75)` before any model-block use of `beta`, and inlined the deterministic `logits = beta * utility` expression in the likelihood. This preserves the same posterior/log density while satisfying SafeStan's parameter-use discipline. No data changes were required.
