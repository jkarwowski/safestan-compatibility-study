# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood scores `log_earn = log(earn)`, a transformed-data quantity derived from top-level data `earn`.

Generated files: none.

Reason: the observed quantity on the left side of the sampling statement is `log_earn`, which is not a top-level data variable. Making this SafeStan-compatible would require changing the protected interface, for example by adding a new top-level log-transformed observation or changing the likelihood to a distribution on `earn`; that is not a deterministic copy/reshape-only rewrite. In addition, the parameters `alpha`, `beta`, and `sigma` have no explicit priors, and adding proper built-in priors would change the model density. Therefore this model requires a substantive rewrite rather than a minor SafeStan translation.
