# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is applied to indexed elements `y[n]` inside a loop, which would require a minor vectorization rewrite under SafeStan. However, the model also has improper flat priors for the positive scale parameters `sigma_y`, `sigma_alpha`, and `sigma_beta`. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding proper priors for these scale parameters would change the posterior/log density, and there is no density-preserving built-in sampling statement for the original improper half-flat priors. Therefore a SafeStan-compatible version cannot be produced without a substantive density change.
