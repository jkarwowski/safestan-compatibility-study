# SafeStan Safety Note

Compatibility: major.

Protected data: no SafeStan protected interface was generated. The original likelihood scores the transformed-data quantity `sqrt_dif`, deterministically computed from `score_1` and `score_2`.

Generated files: none.

Reason: the program is not SafeStan-compatible as written because the observed likelihood is applied to `sqrt_dif`, which is not a top-level data variable, and the parameters `b`, `sigma_a`, and `sigma_y` have no explicit built-in priors. Adding priors for these parameters would change the posterior density, so this cannot be repaired by a minor same-density rewrite.
