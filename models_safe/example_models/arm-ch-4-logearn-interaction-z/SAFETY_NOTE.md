# SafeStan Safety Note

Compatibility: major.

Protected data choice: the original likelihood scores `log_earn`, a transformed-data value computed as `log(earn)` from the top-level data variable `earn`. No SafeStan protected variable is emitted.

Generated files: none.

Reason: the observed quantity on the left side of the sampling statement is not a plain top-level data variable; it is a transformed-data value. Making this SafeStan-compatible would require either adding a new top-level `log_earn` observation computed by a non-copy transformation of `earn`, or changing the likelihood to one on `earn` itself, which would change the target density. In addition, the parameters `alpha`, `beta`, and `sigma` have no explicit proper priors in the original model; adding such priors would substantively change the model. Therefore this model cannot be translated to SafeStan with only minor same-density rewrites.
