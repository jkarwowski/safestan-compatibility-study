# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program contains no model-block sampling statements and no observed data likelihood.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; all top-level data are context inputs used only to generate simulated quantities, and the program contains no parameters, no protected observations, and no arbitrary log-density manipulation.
