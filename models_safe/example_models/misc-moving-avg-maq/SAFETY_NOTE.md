# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because the original model computes the moving-average residual recursion in `transformed parameters` using `y` before the likelihood statement. SafeStan protected data cannot be referenced before being observed, nor in transformed blocks. The recursion now uses `y_safestan_copy` as a context input, while the protected variable `y` is scored exactly once with the original built-in normal likelihood. The added data field satisfies `y_safestan_copy = y` elementwise.
