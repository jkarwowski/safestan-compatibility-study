# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood scores `logCObs`, a transformed-data value defined as `log(cObs)`. No SafeStan protected interface is emitted for this major case.

Generated files: none.

Reason: the model cannot be translated to SafeStan with only minor same-density changes. In particular, parameter `ka` is used in the likelihood through `theta`, the algebraic solver, `cHat`, and `cHatObs`, but it has no explicit prior sampling statement. Its Stan constraint `real<lower = 0> ka;` gives only an improper implicit prior on the positive reals; adding any proper built-in prior would change the posterior. The likelihood also scores a transformed-data quantity (`logCObs`) rather than a top-level data variable, which would require an interface/data rewrite. Because satisfying SafeStan would require a substantive density change, no `model_safe.stan` or `data_safe.json` is generated.
