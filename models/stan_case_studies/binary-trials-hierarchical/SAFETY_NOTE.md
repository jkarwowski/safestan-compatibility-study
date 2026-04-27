# SafeStan Safety Note

Compatibility: minor.

Protected data: `y` (initial successes observed by the binomial likelihood). `y_new` is held-out data used only in generated quantities for posterior predictive log density and is not a target/likelihood contribution.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, and used it for the transformed-data summaries (`min_y`, `max_y`, `mean_y`, `sd_y`) because protected data cannot be read in `transformed data` before observation. Added `phi ~ uniform(0, 1)`, which is density-neutral for `phi` already constrained to `[0, 1]`, making the implicit bounded uniform prior explicit. The likelihood remains `y ~ binomial(K, theta)`.
