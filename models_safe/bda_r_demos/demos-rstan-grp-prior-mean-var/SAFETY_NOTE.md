# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement. Other data variables (`N`, `K`, and `x`) are context inputs used as sizes/indices/predictors and are not scored as observations. Each parameter has exactly one built-in prior before later use.
