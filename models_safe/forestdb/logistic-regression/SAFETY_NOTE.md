# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement, `y ~ bernoulli_logit(X * beta)`, after the parameter prior `beta ~ normal(0, 3)`. Context inputs `N`, `K`, and `X` are not scored as observations.
