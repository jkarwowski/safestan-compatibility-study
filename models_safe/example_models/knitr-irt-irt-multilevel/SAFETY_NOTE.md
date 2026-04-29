# SafeStan Safety Note

Compatibility: minor.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the protected observation `y` is already a top-level data variable and is scored exactly once with `y ~ bernoulli_logit(log_odds)`. The model needed SafeStan parameter-discipline repairs: the hyperparameter priors were moved before dependent priors, and explicit `uniform(0, 20)` priors were added for `sigma_beta`, `sigma_gamma`, and `sigma_delta`, matching their existing finite bounds. No data fields were added or changed.
