# SafeStan Safety Note

Compatibility: major.

Protected data choice: the likelihood scores `log_earn`, a transformed-data quantity computed as `log(earn)`. No SafeStan protected variable is emitted because no compatible rewrite is generated.

Generated files: none.

Reason: SafeStan requires every parameter to have exactly one built-in prior before it is used. The original model has no priors for `alpha`, `beta`, or `sigma`; adding proper priors would change the posterior/log density. The likelihood also observes a transformed-data value rather than a top-level data variable, which would require an additional deterministic top-level observed quantity in any rewrite. Because preserving the original density would require substantive changes, this model is classified as major.
