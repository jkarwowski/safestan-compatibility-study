# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the model block so each parameter receives its unique built-in prior before it is used in the derived coefficient calculation or likelihood. The local `beta` calculation is placed in a nested block after the priors. No data changes were required; `data_safe.json` is the supplied data unchanged.
