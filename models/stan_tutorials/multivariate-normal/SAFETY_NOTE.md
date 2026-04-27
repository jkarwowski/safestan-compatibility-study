# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed data `y` is scored many times, including through transformed-data aliases (`ry`) and indexed expressions (`y[1]`, `ry[1]`), and the model has unconstrained parameters `beta` and `rbeta` with only implicit improper flat priors. SafeStan requires explicit proper priors before parameter use, and adding such priors would change the posterior/log density. Therefore this cannot be translated with only a minor same-density mechanical rewrite.
