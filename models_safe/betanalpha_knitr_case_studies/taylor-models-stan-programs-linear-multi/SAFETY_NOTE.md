# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `y` is the only top-level data variable scored by a sampling statement; it is observed exactly once with a plain built-in `normal` sampling statement. The remaining data variables are context inputs, and all parameters have built-in priors before later use.
