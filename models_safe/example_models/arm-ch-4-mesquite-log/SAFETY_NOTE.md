# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood scores `log_weight`, a transformed-data value deterministically computed from top-level data `weight`.

Generated files: none.

Reason: the model is not SafeStan-compatible as written because the sampling statement observes `log_weight`, which is not a top-level data variable, and the protected observation is computed in `transformed data` before it is scored. More importantly, the parameters `alpha`, `beta`, and `sigma` have no explicit priors. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for these unconstrained or half-constrained parameters would change the posterior density, so this cannot be repaired by a minor same-density rewrite.
