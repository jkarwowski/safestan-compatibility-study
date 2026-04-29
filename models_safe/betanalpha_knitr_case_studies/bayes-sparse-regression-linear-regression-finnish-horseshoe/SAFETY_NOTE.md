# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ normal(...)`, after all parameters have received their built-in prior sampling statements. The remaining data variables `N`, `M`, and `X` are context inputs used as sizes and predictors, not observed outcomes.
