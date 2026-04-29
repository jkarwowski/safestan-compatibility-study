# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; `y` is a top-level data variable observed exactly once with the built-in `poisson_log` sampling statement. Each top-level parameter has one built-in prior before the protected observation is used, and the remaining data variables are context inputs.
