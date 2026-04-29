# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: moved the deterministic construction of the local model-block coefficient vector `beta` until after the parameter prior sampling statements. This preserves the posterior density but satisfies SafeStan's rule that parameters must receive their unique built-in prior before they are used in the model block. No data changes were required.
