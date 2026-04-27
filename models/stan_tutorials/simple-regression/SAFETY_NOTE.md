# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes the top-level protected data `y` with a plain vectorized sampling statement, but the parameters `a`, `b`, and `sigma` have only implicit improper flat priors. SafeStan requires explicit proper priors, and adding such priors would change the posterior/log density. Therefore no same-density SafeStan translation is available as a minor mechanical rewrite.
