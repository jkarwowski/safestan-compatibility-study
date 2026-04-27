# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No model changes were required. The protected observations are top-level data and are scored by the plain vectorized sampling statement `y ~ bernoulli_logit(eta)`. The model uses explicit proper priors before the likelihood and does not use `target +=`, direct `_lpdf`/`_lpmf` scoring, transformed-data access to protected observations, or user-defined probability distributions for protected observations.
