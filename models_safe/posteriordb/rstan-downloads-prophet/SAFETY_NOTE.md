# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic top-level copy of `y`. The original likelihood was inside an `if`/`else if` on `trend_indicator`, so `y` was not guaranteed to be observed exactly once in SafeStan's static discipline. The rewrite computes `mu_y` and `sigma_y` conditionally, then observes `y` once with a built-in `normal` sampling statement. For `trend_indicator` values other than 0 or 1, the original model contributed no likelihood term for `y`; the rewrite uses `normal(y | y_safestan_copy, 1 / sqrt(2*pi()))`, which has zero log density when `y_safestan_copy` is the deterministic copy of `y` supplied in `data_safe.json`.
