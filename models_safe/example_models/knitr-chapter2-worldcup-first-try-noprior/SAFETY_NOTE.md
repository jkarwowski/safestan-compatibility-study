# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood scores `sqrt_dif`, a transformed-data quantity deterministically computed from `score_1` and `score_2`. No SafeStan protected-variable interface is generated because this case is classified as major.

Generated files: none.

Reason: the original model has parameters `sigma_a` and `sigma_y` with no explicit built-in priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use; adding priors for these positive unbounded scale parameters would change the posterior density. In addition, the observed likelihood target `sqrt_dif` is not a top-level data variable but a transformed-data value. A SafeStan version would therefore require substantive changes rather than a minor same-density translation.
