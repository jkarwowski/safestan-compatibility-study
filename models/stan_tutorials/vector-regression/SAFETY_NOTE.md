# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: although `y` is observed with a plain vectorized sampling statement, the regression coefficients `b` and scale `sigma` have only Stan's implicit improper flat priors on their constrained supports. SafeStan requires explicit proper priors, and adding such priors would change the posterior/log density.
