# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only top-level data variable scored by a sampling statement is `y`, and it is observed exactly once with a plain built-in `normal` sampling statement. The other data variables (`N`, `w`, and `rho`) are context inputs only. Each parameter has exactly one built-in prior sampling statement before it is used in the likelihood.
