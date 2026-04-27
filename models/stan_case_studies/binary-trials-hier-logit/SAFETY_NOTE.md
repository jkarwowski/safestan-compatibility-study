# SafeStan Safety Note

Compatibility: minor.

Protected data: `y` (the observed initial successes used in the posterior likelihood). `y_new` is held-out data used only in generated quantities for posterior predictive reporting and is not observed in the model target.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: added `y_safestan_copy`, a deterministic elementwise copy of `y`, because protected data cannot be read in `transformed data` before its observation. The transformed-data summaries and generated-quantity uses that do not define the likelihood read this copy. The likelihood remains the plain vectorized sampling statement `y ~ binomial_logit(...)`, and the existing proper priors are unchanged.
