# SafeStan Safety Note

Compatibility: minor.

Protected data: `y_linear`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: promoted `y_linear` from a `transformed data` reshaping of `y` to a top-level data variable so it can be the protected observation on the left side of the likelihood. In `data_safe.json`, `y_linear` is deterministically constructed from `y` in the original loop order: `y_linear[(n - 1) * T + t] = y[n, t]`. Reordered the model block so all parameter priors occur before any model-block use of those parameters. The likelihood and posterior density are otherwise unchanged.
