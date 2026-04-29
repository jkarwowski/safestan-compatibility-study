# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is for `y`, but it is written as indexed sampling statements inside a loop (`y[n] ~ normal(...)`), which is not directly SafeStan-compatible. That part could in principle be mechanically vectorized. However, several parameters (`b`, `g_0`, `g_1`, `sigma_y`, and `sigma_a`) have only Stan's implicit improper flat priors, and SafeStan requires every parameter to have exactly one explicit built-in prior before use. Adding proper priors would change the posterior/log density, so a SafeStan-compatible version cannot be produced by a minor same-density rewrite.
