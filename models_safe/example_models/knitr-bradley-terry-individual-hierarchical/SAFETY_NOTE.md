# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observation `y` is a top-level data variable and is scored exactly once with a plain built-in sampling statement, `y ~ bernoulli_logit(...)`, after all parameters have received their priors. The remaining data variables (`K`, `N`, `player0`, and `player1`) are context inputs used as sizes and indices/predictors, not observed likelihood variables.
