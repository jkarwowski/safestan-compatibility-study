# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is observed exactly once with a plain built-in sampling statement, `y ~ bernoulli(theta)`, after the parameter prior `theta ~ beta(1, 1)`. The context input `N` is not scored. Generated-quantities calculations occur after observation and do not alter the model density.
