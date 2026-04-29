# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement. The context input `x` is used only as a predictor, and all parameters have built-in priors before they are used in the likelihood.
