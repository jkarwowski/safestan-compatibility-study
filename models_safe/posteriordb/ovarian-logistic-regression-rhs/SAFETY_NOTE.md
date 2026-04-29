# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with the built-in `bernoulli_logit_glm` sampling statement after all parameters have received built-in priors. The remaining data variables (`n`, `d`, `x`, and prior hyperparameters) are context inputs and are not observed with sampling statements.
