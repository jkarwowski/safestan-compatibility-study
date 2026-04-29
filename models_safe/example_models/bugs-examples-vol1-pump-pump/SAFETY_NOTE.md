# SafeStan Safety Note

Compatibility: as-is.

Protected data: `x`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `x` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `x ~ poisson(theta .* t)`. The other data variables, `N` and `t`, are context inputs used as a size and exposure predictor. Each parameter (`alpha`, `beta`, and `theta`) has exactly one built-in prior before later use.
