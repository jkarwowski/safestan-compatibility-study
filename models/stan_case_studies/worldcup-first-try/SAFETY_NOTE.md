# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood-scored game outcome `sqrt_dif`, a deterministic transform of `score_1` and `score_2`.

Generated files: none.

Reason: although the transformed observation `sqrt_dif` could mechanically be supplied as a top-level data field, the model has implicit improper priors on `b`, `sigma_a`, and `sigma_y`. SafeStan requires explicit proper priors, and adding proper priors for these parameters would change the posterior/log density. Therefore no same-density SafeStan translation is available as a minor rewrite.
