# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program contains no model block, no parameters, and no likelihood sampling statements conditioning on data.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. All top-level data variables are context inputs used only by generated-quantities simulation code; there is no protected observed interface to score.
