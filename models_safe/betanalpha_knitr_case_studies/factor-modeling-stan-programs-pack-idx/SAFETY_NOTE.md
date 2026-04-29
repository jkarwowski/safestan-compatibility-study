# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `model` block, no parameters, and no sampling statements, so it does not condition on any protected data. All declared data variables are context/configuration inputs used only for deterministic index construction.
