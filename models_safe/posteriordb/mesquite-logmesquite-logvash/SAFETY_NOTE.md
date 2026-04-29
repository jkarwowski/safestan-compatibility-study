# SafeStan Safety Note

Compatibility: major.

Protected data: the observed response is `log_weight`, a deterministic `log(weight)` quantity scored by the likelihood in the original model.

Generated files: none.

Reason: the likelihood is applied to `log_weight`, which is a transformed-data local rather than a top-level protected data variable, so a SafeStan version would need a deterministic top-level observed `log_weight` field. More importantly, the parameters `beta` and `sigma` have no explicit proper priors in the original model. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding priors for these unconstrained/lower-bounded parameters would change the posterior/log density, so this cannot be repaired by a minor same-density rewrite.
