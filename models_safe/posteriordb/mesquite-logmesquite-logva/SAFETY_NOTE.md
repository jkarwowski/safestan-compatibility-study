# SafeStan Safety Note

Compatibility: major.

Protected data choice: the modeled observation is `log_weight`, a transformed-data value computed as `log(weight)` from the top-level response `weight`. The predictor/context inputs are `N`, `diam1`, `diam2`, `canopy_height`, and `group`.

Generated files: none.

Reason: the likelihood is written for a transformed-data variable (`log_weight ~ normal(...)`) rather than for a protected top-level data variable. More importantly, the parameters `beta` and `sigma` have no explicit built-in prior sampling statements. SafeStan requires every parameter to be sampled exactly once before use, and adding proper priors for these unconstrained/half-constrained parameters would change the posterior/log density. Therefore this model cannot be translated with only a minor same-density rewrite.
