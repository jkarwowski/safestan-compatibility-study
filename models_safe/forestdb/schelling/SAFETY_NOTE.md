# SafeStan Safety Note

Compatibility: minor.

Protected data: `chosen_action`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter `beta` is sampled from its prior before any use. The original local `logits` computation used `beta` before its prior; the safe version inlines the same expression in the `categorical_logit` likelihood after `beta ~ lognormal(0, 0.75)`. The data are unchanged.
