# SafeStan Safety Note

Compatibility: as-is.

Protected data: `y`.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The protected observations `y` are top-level data and are observed with a plain vectorized sampling statement, `y ~ binomial_logit(K, alpha)`. The model uses explicit proper priors before parameter use and does not use manual `target +=` scoring for the protected observations.
