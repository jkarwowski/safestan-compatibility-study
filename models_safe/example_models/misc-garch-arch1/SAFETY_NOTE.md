# SafeStan Safety Note

Compatibility: major.

Protected data choice: the model conditions on the return data `r` through the indexed observations `r[t]` for `t = 2:T`.

Generated files: none.

Reason: the likelihood is written as loop-indexed sampling statements for elements of `r`, while SafeStan requires a protected top-level data variable to be observed exactly once with a plain identifier outside loops. More importantly, the parameters `mu` and `alpha0` have no explicit proper priors in the original model; adding priors for them would change the posterior/log density. Therefore a SafeStan-compatible version cannot be produced by a minor same-density rewrite.
