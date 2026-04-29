# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic top-level data copy of `y`, because protected data cannot be read in `transformed data` before its sampling statement. The transformed-data computation of `R` now uses `y_safestan_copy`; the likelihood still observes the protected variable `y` exactly once with `y ~ normal(...)`. The added data field satisfies `y_safestan_copy = y` elementwise.
