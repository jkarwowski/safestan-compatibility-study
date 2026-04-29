# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: reshaped the observed response `y` from an `N` by `T` matrix into a length `N * T` vector in row-major order: `y[(n - 1) * T + t]` equals the original matrix entry `y[n, t]`. The nested elementwise likelihood was replaced by one vectorized built-in sampling statement on the plain top-level protected variable `y`, outside loops. The linear predictors are computed deterministically in the same row-major order after all parameter priors, preserving the original joint density.
