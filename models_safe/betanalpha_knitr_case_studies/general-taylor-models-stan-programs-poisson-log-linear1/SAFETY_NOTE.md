# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a built-in distribution using a plain sampling statement. The context inputs `M`, `N`, `x0`, and `X` are not scored as observations, and both parameters have explicit built-in priors before use in the likelihood.
