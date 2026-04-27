# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`, the observed initial successes contributing to the posterior likelihood through `y ~ binomial(K, phi)`. `K` is trial-count data. `y_new` and `K_new` are used only in generated quantities for posterior predictive summaries and are not target-scored.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic copy of `y`, because the original `transformed data` block read protected data to compute summary statistics before the likelihood observation. Non-likelihood summary reads of `y` were replaced by this copy. Added `phi ~ uniform(0, 1)`, which is density-neutral for a parameter already constrained to `[0, 1]`. The likelihood remains the same vectorized sampling statement, `y ~ binomial(K, phi)`.
