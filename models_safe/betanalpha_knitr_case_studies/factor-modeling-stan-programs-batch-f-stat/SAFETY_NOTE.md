# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no `model` block, no sampling statements, and no data variable is scored as an observation.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. All top-level data variables are used only as context inputs for the generated-quantities statistic, and there are no parameters or likelihood terms requiring SafeStan protection.
