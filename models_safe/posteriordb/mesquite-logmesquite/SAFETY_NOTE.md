# SafeStan Safety Note

Compatibility: major.

Protected data choice: the model observes the response through `log_weight = log(weight)`. A SafeStan rewrite would need a top-level protected data variable such as `log_weight`, deterministically computed as `log(weight)` from the supplied data.

Generated files: none.

Reason: although the transformed response could be made top-level by a deterministic data augmentation, the parameters `beta` and `sigma` have no explicit priors in the original model. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for unconstrained `beta` or lower-bounded `sigma` would change the posterior/log density, so this cannot be represented as a minor same-density rewrite.
