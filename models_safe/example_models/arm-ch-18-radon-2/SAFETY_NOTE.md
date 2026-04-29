# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood scores `y` via indexed sampling statements inside a loop. That part could in principle be mechanically vectorized, but the model also has top-level parameters (`b`, `g_0`, `g_1`, `sigma_y`, and `sigma_a`) with only implicit improper flat priors. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for these parameters would change the posterior/log density, and there are no finite-bounded implicit proper priors that can be made explicit without changing the model. Therefore a SafeStan-compatible version cannot be produced by a minor same-density rewrite.
