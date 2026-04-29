# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no `model` block, no parameters, and no sampling statements; all top-level data variables are context inputs used for deterministic transformed-data and generated-quantities calculations, not protected observations.
