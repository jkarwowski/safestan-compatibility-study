# SafeStan Safety Note

Compatibility: minor.

Protected data: `chosen_action`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so that the parameter `beta` receives its built-in prior before being used to compute `logits`. This preserves the same posterior/log density. No data changes were required.
