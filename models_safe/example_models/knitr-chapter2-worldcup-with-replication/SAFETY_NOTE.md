# SafeStan Safety Note

Compatibility: major.

Protected data: no SafeStan protected-variable list is generated. The original likelihood scores `sqrt_dif`, a transformed-data quantity computed from top-level data `score_1` and `score_2`.

Generated files: none.

Reason: the observed quantity on the left side of the likelihood is not a top-level data variable, but a nonlinear transformed-data value. Replacing it with SafeStan sampling statements would require changing the protected interface or adding a new derived observation rather than a simple copy/reshape. Also, parameters `b`, `sigma_a`, and `sigma_y` have only Stan's implicit improper priors; adding proper built-in priors would change the posterior density. Therefore this is not a minor same-density SafeStan translation.
