# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. `N1` and `N2` are context inputs used only as array sizes for generated quantities; they are not observed/scored by the model.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The program contains no model-block likelihood or parameter priors, no protected observations, and no forbidden manual log-density manipulation.
