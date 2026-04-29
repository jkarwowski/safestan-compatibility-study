# SafeStan Safety Note

Compatibility: minor.

Protected data: `chosen_action`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model-block computations so the parameter `beta` receives its built-in prior before it is used in the likelihood expression. The local `logits` helper was inlined as `beta * utility`; this is a same-density mechanical rewrite. No data fields were added or changed.
