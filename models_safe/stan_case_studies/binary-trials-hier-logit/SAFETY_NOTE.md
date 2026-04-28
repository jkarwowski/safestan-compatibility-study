# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic elementwise copy of `y`, because protected data cannot be read in `transformed data` before its likelihood statement. The copy is also used for generated-quantities summaries that originally referenced `y` outside the likelihood. The protected variable `y` is now used exactly once, as the plain left-hand side of `y ~ binomial_logit(K, mu + sigma * alpha_std);`. Parameter priors were already explicit and ordered before parameter use. The posterior/log density is unchanged when `y_safestan_copy[i] = y[i]` for all `i = 1, ..., N`.
