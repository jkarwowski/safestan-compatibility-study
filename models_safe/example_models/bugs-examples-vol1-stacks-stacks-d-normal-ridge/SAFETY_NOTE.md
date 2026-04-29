# SafeStan Safety Note

Compatibility: as-is.

Protected data: `Y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required; `Y` is the only top-level data variable scored by a sampling statement, it is observed exactly once with a plain built-in `normal` sampling statement, and all parameters have one built-in prior before they are used in the likelihood.
