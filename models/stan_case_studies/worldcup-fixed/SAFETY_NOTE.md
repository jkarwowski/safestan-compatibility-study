# SafeStan Safety Note

Compatibility: major.

Protected data: `sqrt_dif`, the deterministic transformed score difference computed from `score_1` and `score_2` and scored by the Student-t likelihood.

Generated files: none.

Reason: although the transformed-data likelihood input could be made top-level data mechanically, the model has implicit improper priors on `b`, `sigma_a`, and `sigma_y`. SafeStan requires explicit proper priors, and adding such priors would change the posterior/log density. Therefore no same-density SafeStan translation is available as a minor rewrite.
