# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy exactly equal to `y`, so summaries and non-likelihood generated quantities can read the copy while protected `y` is observed by the plain top-level sampling statement `y ~ binomial(K, theta)`. Added `theta ~ uniform(0, 1)` before the likelihood; this is density-neutral because `theta` was already constrained to `[0, 1]`. `y_new` is used only in generated quantities for posterior predictive log density and is not part of the posterior target.
