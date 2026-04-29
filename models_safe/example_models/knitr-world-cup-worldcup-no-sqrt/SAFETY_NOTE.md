# SafeStan Safety Note

Compatibility: major.

Protected data: the observed likelihood is applied to `dif`, where `dif = score_1 - score_2` is computed in `transformed data`. A SafeStan rewrite would need a deterministic top-level protected data variable for this difference.

Generated files: none.

Reason: although the transformed-data observation could be made SafeStan-compatible by adding a deterministic top-level `dif` field, the model has parameters `b`, `sigma_a`, and `sigma_y` with no explicit built-in priors. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding proper priors for these parameters would change the posterior/log density, and their implicit improper flat densities cannot be represented as allowed SafeStan priors by a minor same-density rewrite.
