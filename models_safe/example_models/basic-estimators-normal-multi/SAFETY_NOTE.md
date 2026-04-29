# SafeStan Safety Note

Compatibility: major.

Protected data: `y`. The variables `N`, `J`, `z`, and `sigma` are context inputs; `ry` is a transformed-data copy/reshape of `y`, not a top-level protected data variable.

Generated files: none.

Reason: the original model scores `y` many times, including indexed left-hand sides such as `y[1]`, and also scores transformed data derived from `y` (`ry` and `ry[1]`). SafeStan requires each protected top-level data variable to be observed exactly once with a plain identifier before any other use. In addition, the parameters `beta` and `rbeta` have no built-in proper prior sampling statements; adding priors for these unconstrained parameters would change the posterior density. Therefore a SafeStan-compatible version cannot be produced by a minor same-density rewrite.
