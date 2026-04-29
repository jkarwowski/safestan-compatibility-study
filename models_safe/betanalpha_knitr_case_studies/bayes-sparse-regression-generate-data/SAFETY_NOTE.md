# SafeStan Safety Note

Compatibility: as-is.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program has no data block and no model-block likelihood or sampling statements conditioning on observed data; it only defines constants in `transformed data` and simulates values in `generated quantities` using RNG functions. Therefore there is no protected data interface for SafeStan to observe.
