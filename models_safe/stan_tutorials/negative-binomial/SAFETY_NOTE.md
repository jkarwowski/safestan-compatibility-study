# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. `y` is a top-level data variable observed exactly once with a plain built-in sampling statement, and the parameters `alpha` and `beta` each have exactly one built-in prior before being used in the likelihood. `N` is context data.
