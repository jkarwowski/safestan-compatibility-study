# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program contains no model block and no sampling statements that condition on top-level data, so there is no protected likelihood interface to declare.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. All top-level data are context inputs used only for deterministic generated-quantities calculations, and the program contains no parameters, likelihood sampling statements, manual `target +=` scoring, or other SafeStan-forbidden log-density manipulation.
