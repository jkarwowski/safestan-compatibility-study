# SafeStan Safety Note

Compatibility: minor.

Protected data: `chosen_action`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the use of parameter `beta` so that its built-in prior sampling statement `beta ~ lognormal(0, 0.75)` occurs before any model-block use of `beta`. The local helper `logits` was inlined in the categorical likelihood as `beta * utility`. This preserves the same posterior/log density. The data are unchanged.
