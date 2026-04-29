# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the response array). The other top-level data variables (`I`, `J`, `N`, `ii`, `jj`, `K`, and `W`) are context inputs.

Generated files: none.

Reason: the likelihood for `y` is accumulated with `target += rsm(y[n], ...)` inside a loop, where `rsm` is a user-defined log-probability helper around an observation-specific categorical distribution. SafeStan forbids arbitrary `target +=`, user-defined distribution paths for observations, and protected observation scoring inside loops/indexed left-hand sides. Replacing this with a single built-in SafeStan sampling statement would require a substantive reformulation rather than a minor mechanical rewrite. The model also uses `target +=` priors on transformed parameters `beta` and `kappa`, which are not top-level parameter prior sampling statements. Therefore no minor same-density SafeStan translation is provided.
