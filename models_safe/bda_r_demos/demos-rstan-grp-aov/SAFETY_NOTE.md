# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. The other data variables (`N`, `K`, and `x`) are context inputs used only for sizes and indexing/prediction. Parameters `mu` and `sigma` each have exactly one built-in prior before they are used in the likelihood.
