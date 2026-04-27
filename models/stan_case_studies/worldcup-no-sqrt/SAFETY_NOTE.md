# SafeStan Safety Note

Compatibility: major.

Protected data: `score_1` and `score_2`, which are scored only through the deterministic difference `dif = score_1 - score_2` in the Student-t likelihood.

Generated files: none.

Reason: the likelihood observation `dif` is computed from protected data in `transformed data` rather than supplied as a top-level observed variable. That part could be mechanically repaired by adding a deterministic `dif` field to the data, but the model also relies on implicit improper priors for `b`, `sigma_a`, and `sigma_y`. SafeStan requires explicit proper priors, and adding any proper priors for these parameters would change the posterior/log density. Therefore this case cannot be translated without a substantive density change.
