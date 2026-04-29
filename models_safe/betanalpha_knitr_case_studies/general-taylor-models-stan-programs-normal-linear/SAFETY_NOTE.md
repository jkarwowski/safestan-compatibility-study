# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The only observed data variable scored by a sampling statement is the top-level data variable `y`, and it is observed exactly once with the built-in distribution `normal`. The context inputs `M`, `N`, `x0`, and `X` are not protected; they are used only as sizes, baselines, and predictors. All parameters have built-in prior sampling statements before their later use, and the model does not use forbidden direct log-density manipulation.
