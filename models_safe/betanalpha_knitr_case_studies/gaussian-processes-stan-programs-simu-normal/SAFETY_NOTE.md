# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The Stan program does not condition on or score any top-level data variable in the `model` block.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no parameters, no sampling statements, and no arbitrary `target` manipulation; all top-level data variables are context inputs used to construct generated quantities.
