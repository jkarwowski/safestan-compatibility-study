# SafeStan Safety Note

Compatibility: major.

Protected data: the observed game scores `score_1` and `score_2`, through the derived likelihood variable `sqrt_dif = (step(score_1 - score_2) - 0.5) .* sqrt(abs(score_1 - score_2))`.

Generated files: none.

Reason: although the derived observation `sqrt_dif` could be made a top-level deterministic data field, the model relies on implicit improper priors for the positive scale parameters `sigma_a` and `sigma_y`. SafeStan requires explicit proper priors, and adding proper priors to these unbounded parameters would change the posterior/log density.
