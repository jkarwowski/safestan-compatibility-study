# SafeStan Safety Note

Compatibility: minor.

Protected data: none. The model has no top-level data variables and no observed likelihood terms.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reordered the two parameter sampling statements so that `tau` receives its prior before it is used as the scale in the prior for `x`. This preserves the same joint density because the original model contained only multiplicative built-in prior factors.
